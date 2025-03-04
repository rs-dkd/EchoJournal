import SwiftUI

struct JournalView: View{
    @Binding var selectedTab: BottomNavBar.Tab
    @Binding var isNightMode: Bool
    @Binding var entries: [JournalEntry]
    @State private var showSettings = false
    @State private var selectedEntry: JournalEntry?
    
    var body: some View{
        VStack{
            HStack{
                Text("My Journal")
                    .font(.custom("American Typewriter", size: 40))
                    .foregroundColor(isNightMode ? .white : .black)
                    .padding(.leading)
                Spacer()
                Button(action:{showSettings.toggle()}){
                    Image(systemName: "gear")
                        .font(.largeTitle)
                        .foregroundColor(isNightMode ? .white : .black)
                        .padding(.trailing)
                }
            }
            
            ScrollViewReader{scrollView in
                ScrollView{
                    VStack{
                        ForEach(entries.sorted(by:{$0.date < $1.date})){entry in
                            VStack(alignment: .leading){
                                Text(entry.date, style: .date)
                                    .font(.custom("American Typewriter", size: 25))
                                    .foregroundColor(isNightMode ? .white : .black)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                                Text(entry.title)
                                    .font(.custom("American Typewriter", size: 20))
                                    .foregroundColor(isNightMode ? .gray : .black)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(isNightMode ? Color.black.opacity(0.6) : Color.white.opacity(0.9))
                            )
                            .shadow(color: isNightMode ? Color.white.opacity(0.2) : Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .id(entry.id)
                            .onTapGesture{
                                selectedEntry = entry
                            }
                        }
                    }
                }
                .onAppear{
                    if let lastEntry = entries.last{
                        scrollView.scrollTo(lastEntry.id, anchor: .bottom)
                    }
                }
            }
            
            Spacer()
        }
        .background(isNightMode ? Color.black : Color.white)
        .navigationBarHidden(true)
        .sheet(isPresented: $showSettings){
            SettingsView()
        }
        .fullScreenCover(item: $selectedEntry){entry in
            JournalEntryView(
                entry: Binding(
                    get:{entry},
                    set:{newValue in
                        print("JournalView updating entry: \(newValue)")
                        selectedEntry = newValue
                        if let index = entries.firstIndex(where:{$0.id == entry.id}){
                            entries[index] = newValue
                            print("Updated entry in entries array: \(entries[index])")
                        }
                    }
                ),
                entries: $entries,
                isNightMode: $isNightMode,
                isDismiss:{
                    selectedEntry = nil
                },
                onSave:{ savedEntry in
                    if let index = entries.firstIndex(where:{$0.id == savedEntry.id}){
                        entries[index] = savedEntry
                    }else{
                        entries.append(savedEntry)
                    }
                    selectedEntry = nil
                }
            )
        }
    }
}
