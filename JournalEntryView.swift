import SwiftUI

struct JournalEntryView: View{
    @Binding var entry: JournalEntry
    @Binding var entries: [JournalEntry]
    @Environment(\.presentationMode) private var presentationMode
    @State private var showAIAnalysis = false
    @State private var selectedDate = Date()
    @State private var showAIAnalysisView = false
    @State private var dismissAfterAnalysis = false
    @State private var selectedImages: [UIImage] = []
    @State private var selectedImage: UIImage? = nil
    @State private var showPhotoPicker = false
    @State private var duplicateEntryAlert = false
    @State private var beenAnalyzed = false
    @Binding var isNightMode: Bool
    
    var isDismiss: (() -> Void)?
    var onSave: ((JournalEntry) -> Void)?
    
    init(entry: Binding<JournalEntry>, entries: Binding<[JournalEntry]>, isNightMode: Binding<Bool>, isDismiss:(() -> Void)?, onSave: ((JournalEntry) -> Void)?){
        self._entry = entry
        self._entries = entries
        self._isNightMode = isNightMode
        self.isDismiss = isDismiss
        self.onSave = onSave
        self._selectedDate = State(initialValue: entry.wrappedValue.date)
        let images = entry.wrappedValue.images.compactMap{UIImage(data:$0)}
        self._selectedImages = State(initialValue:images)
        self._beenAnalyzed = State(initialValue: entry.wrappedValue.emotion?.isEmpty == false)
    }
    var body: some View{
        NavigationView{
            VStack{
                HStack{
                    Button(action:{
                        isDismiss?()
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(isNightMode ? .white : .black)
                            .padding(.leading)
                    }
                    Spacer()
                    HStack{
                        Text("Select Date:")
                            .font(.custom("American Typewriter", size: 20))
                            .foregroundColor(isNightMode ? .white : .black)
                        CustomDatePicker(selectedDate: Binding(get: {selectedDate},set:{newValue in
                            selectedDate = newValue
                            entry.date = newValue}),
                                         isNightMode: $isNightMode
                        )
                    }
                    .padding(.leading)
                    Spacer()
                    Button(action: saveEntry){
                        Text("Save")
                            .font(.custom("American Typewriter", size: 20))
                            .foregroundColor(isNightMode ? .white : .black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.brown)
                            .cornerRadius(5)
                            .padding(.trailing)
                    }
                }
                
                TextField("", text: $entry.title)
                    .font(.custom("American Typewriter", size: 30))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(isNightMode ? Color.black : Color.white)
                    .textFieldPlaceholder(when: entry.title.isEmpty) {
                        Text("Title")
                            .font(.custom("American Typewriter", size: 30))
                            .foregroundColor(isNightMode ? .gray.opacity(0.8) : .black.opacity(0.6))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .allowsHitTesting(false)
                    }
                ZStack(alignment: .topLeading){
                    TextEditor(text: $entry.text)
                        .font(.custom("American Typewriter", size: 18))
                        .frame(height: 350)
                        .scrollContentBackground(.hidden)
                        .background(isNightMode ? Color.black : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .textEditorPlaceholder(when: entry.text.isEmpty){
                            Text("Write your journal entry here...")
                                .font(.custom("American Typewriter", size: 18))
                                .foregroundColor(isNightMode ? .gray.opacity(0.8) : .black.opacity(0.6))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .allowsHitTesting(false)
                        }
                }
                
                
                if !entry.images.isEmpty{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 8){
                            ForEach(Array(entry.images.enumerated()), id: \.offset){ index, imageData in
                                if let uiImage = UIImage(data: imageData){
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 150, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .padding(.horizontal, 4)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .frame(height: 160)
                }
                
                HStack{
                    Button(action:{
                        showPhotoPicker = true
                    }){
                        Text("Add Photo")
                            .font(.custom("American Typewriter", size: 18))
                            .foregroundColor(isNightMode ? .white : .black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(Color.brown)
                            .cornerRadius(5)
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
            .background(isNightMode ? Color.black : Color.white)
            .foregroundColor(isNightMode ? .white : .black)
            .navigationBarHidden(true)
            .alert("Analyze Mood?", isPresented: $showAIAnalysis){
                Button("Yes"){
                    analyzeEmotion(journalText: entry.text) { analyzedEmotion, analyzedEmoji, analyzedRecommendations in
                                            DispatchQueue.main.async {
                                                var updatedEntry = entry
                                                updatedEntry.emotion = analyzedEmotion
                                                updatedEntry.emoji = analyzedEmoji
                                                updatedEntry.recommendations = analyzedRecommendations
                                                entry = updatedEntry
                                                showAIAnalysisView = true
                                                dismissAfterAnalysis = true
                                            }
                        }
                }
                Button("No", role: .cancel){
                    isDismiss?()
                    presentationMode.wrappedValue.dismiss()
                }
            } message:{
                Text("Would you like to analyze this entry?")
            }
            .fullScreenCover(isPresented: $showAIAnalysisView){
                AIAnalysisView(journalText: entry.text, entry: $entry, isPresented: $showAIAnalysisView){
                    if dismissAfterAnalysis{
                        isDismiss?()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $showPhotoPicker){
                PhotoPicker(selectedImage: $selectedImage)
            }
            .onChange(of: selectedImage){ newImage in
                if let newImage = newImage{
                    selectedImages.append(newImage)
                    self.selectedImage = nil
                    if let imageData = newImage.jpegData(compressionQuality:0.6){
                        entry.images.append(imageData)
                    }
                }
            }
        }
        .alert("Duplicate Entry", isPresented: $duplicateEntryAlert){
            Button("OK", role: .cancel){}
        }message:{
            Text("An entry already exists for this date.")
        }
    }
    
    func saveEntry(){
        if entries.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) && $0.id != entry.id}){
            duplicateEntryAlert = true
            return
        }
        var updatedEntry = entry
        updatedEntry.date = selectedDate
        entry = updatedEntry
        if let existingIndex = entries.firstIndex(where: {$0.id == entry.id}){
            entries[existingIndex] = entry
        }else{
            onSave?(updatedEntry)
        }
            showAIAnalysis = true
    }
}
