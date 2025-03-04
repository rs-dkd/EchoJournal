import SwiftUI

struct BottomNavBar: View{
    enum Tab{
        case journal, moodBoard, addEntry
    }
    
    @Binding var selectedTab: Tab
    var body: some View{
        HStack(spacing: 0){
            Button(action:{
                selectedTab = .journal
            }){
                Image(systemName: "book")
                    .font(.system(size: 30))
                    .foregroundColor(selectedTab == .journal ? .white : .black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action:{
                selectedTab = .addEntry
            }){
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .frame(width: 80, height: 80)
            .background(Color.brown)
            .clipShape(Circle())
            .offset(y: -20)
            Button(action:{
                selectedTab = .moodBoard
            }){
                Image(systemName: "calendar")
                    .font(.system(size: 30))
                    .foregroundColor(selectedTab == .moodBoard ? .white : .black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal)
        .frame(height: 80)
        .background(Color(red: 0.4, green: 0.3, blue: 0.2))
        .edgesIgnoringSafeArea(.bottom)
    }
}
