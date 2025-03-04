import SwiftUI
import CoreML

struct AIAnalysisView: View{
    let journalText: String
    @Binding var entry: JournalEntry
    @State private var emotion: String = "Analyzing..."
    @State private var emotionEmoji: String = "🔄"
    @State private var recommendations: [String] = []
    @Environment(\.presentationMode) private var presentationMode
    @AppStorage("isNightMode") private var isNightMode = false
    @Binding var isPresented: Bool
    var onDismiss: (() -> Void)?
    var onSave: ((JournalEntry) -> Void)?
    
    var body: some View{
        ZStack{
            (isNightMode ? Color.black : Color.white)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Emotion Analysis")
                    .font(.custom("American Typewriter", size: 40))
                    .foregroundColor(isNightMode ? .white : .black)
                
                Text("Predicted Emotion: \(emotion)")
                    .font(.custom("American Typewriter", size: 25))
                    .padding()
                    .foregroundColor(isNightMode ? .white : .black)
                
                Text(emotionEmoji)
                    .font(.system(size: 50))
                    .padding()
                    .foregroundColor(isNightMode ? .white : .black)
                
                Text("Recommendations:")
                    .font(.custom("American Typewriter", size: 30))
                    .foregroundColor(isNightMode ? .white : .black)
                
                List(recommendations, id: \.self) { recommendation in
                    Text(recommendation)
                        .font(.custom("American Typewriter", size: 20))
                        .foregroundColor(isNightMode ? .white : .black)
                        .listRowBackground(isNightMode ? Color.black : Color.white)
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                
                Spacer()
                Button(action:{
                    var updatedEntry = entry
                    updatedEntry.emotion = emotion
                    updatedEntry.emoji = emotionEmoji
                    updatedEntry.recommendations = recommendations
                    entry = updatedEntry
                    onSave?(updatedEntry)
                    print("Updated entry: \(entry)")
                    isPresented = false
                    onDismiss?()
                }){
                    Text("Close")
                        .font(.custom("American Typewriter", size: 25))
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .onAppear{
            analyzeEmotion(journalText: journalText){ analyzedEmotion, analyzedEmoji, analyzedRecommendations in
                DispatchQueue.main.async{
                    self.emotion = analyzedEmotion
                    self.emotionEmoji = analyzedEmoji
                    self.recommendations = analyzedRecommendations
                }
            }
        }
    }
}
func analyzeEmotion(journalText: String, completion: @escaping @Sendable(String, String, [String]) -> Void){
    DispatchQueue.global().async{
        do{
            let model = try toneDetectorAI(configuration: MLModelConfiguration())
            
            let prediction = try model.prediction(text: journalText)
            let predictedEmotion = prediction.label
            
            let (emotionText, emoji) = emotionAndEmoji(for: predictedEmotion)
            
            let recommendations = generateRecommendations(for: predictedEmotion)
            
            DispatchQueue.main.async{
                completion(emotionText, emoji, recommendations)
            }
        }catch{
            print("Error analyzing emotion: \(error)")
            DispatchQueue.main.async{
                completion("Neutral", "😐", ["Unable to analyze emotion."] )
            }
        }
    }
}

func emotionAndEmoji(for emotion: String) -> (String, String){
    switch emotion{
    case "Happy":
        return("Happy", "😊")
    case "Sad":
        return("Sad", "😢")
    case "Angry":
        return("Angry", "😡")
    case "Calm":
        return("Calm", "😌")
    default:
        return("Neutral", "😐")
    }
}
func generateRecommendations(for emotion: String) -> [String]{
    switch emotion{
    case "Happy":
        return ["Celebrate your day!", "Express gratitude for all the good things in your life.", "Listen to music to keep you upbeat!", "Share your happiness with others around you.", "Do something nice for a family member or friend."]
    case "Sad":
        return ["Talk to someone you trust.", "Write down all your feelings in the journal", "Take part in relaxing activities such as painting or going on a walk.", "Write a letter for your future self with words of encouragement.", "Listen to music that helps calm you down."]
    case "Angry":
        return ["Take deep breaths.", "Write down everything making you angry and reflect on it.", "Practice meditation and relaxation.", "Go for a walk to help clear your mind.", "Release your energy in a physical activity such as running or boxing."]
    case "Calm":
        return ["Meditate for 5 minutes.", "Enjoy a quiet moment.", "Take part in a yoga stretch.", "Reflect on your moment of calm and peace.", "Listen to white noise and relaxing music."]
    default:
        return ["Take a moment to reflect.", "Write about your feelings."]
    }
}
