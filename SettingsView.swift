import SwiftUI

struct SettingsView: View{
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isNightMode") private var isNightMode = false
    
    var body: some View{
        NavigationView{
            VStack{
                Toggle("Night Mode", isOn: $isNightMode)
                    .font(.custom("American Typewriter", size: 30))
                    .padding()
                
                Spacer()
                
                Button(action:{
                    dismiss()
                }){
                    Text("Close")
                        .font(.custom("American Typewriter", size: 30))
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarHidden(true)
            .background(isNightMode ? Color.black : Color.white)
            .foregroundColor(isNightMode ? .white : .black)
        }
    }
}
