import SwiftUI

struct ContentView: View{
    @State private var selectedTab: BottomNavBar.Tab = .journal
    @AppStorage("isNightMode") private var isNightMode = false
    @State private var entries: [JournalEntry] = []
    @State private var newEntry: JournalEntry? = nil
    
    var body: some View{
        if #available(iOS 17.0, *){
            VStack{
                if selectedTab == .journal{
                    JournalView(
                        selectedTab: $selectedTab,
                        isNightMode: $isNightMode,
                        entries: $entries
                    )
                }else if selectedTab == .moodBoard{
                    MoodBoardView(selectedTab: $selectedTab, isNightMode: $isNightMode, entries: $entries)
                }else if selectedTab == .addEntry{
                    if let newEntry = newEntry{
                        JournalEntryView(
                            entry: Binding(
                                get:{newEntry},
                                set:{updatedEntry in
                                    print("ContentView updating entry: \(updatedEntry)")
                                    self.newEntry = updatedEntry
                                    if let index = entries.firstIndex(where: {$0.id == updatedEntry.id}){
                                        entries[index] = updatedEntry
                                        print("Updated entry in entries array: \(entries[index])")
                                    }
                                }
                            ),
                            entries: $entries,
                            isNightMode: $isNightMode,
                            isDismiss:{
                                selectedTab = .journal
                            },
                            onSave:{ savedEntry in
                                entries.append(savedEntry)}
                        )
                    }else{
                        Text("Starting...")
                    }
                }
                
                BottomNavBar(selectedTab: $selectedTab)
            }
            .background(isNightMode ? Color.black : Color.white)
            .foregroundColor(isNightMode ? .white : .black)
            .edgesIgnoringSafeArea(.bottom)
            .onChange(of: selectedTab){ oldValue, newValue in
                if newValue == .addEntry{
                    newEntry = JournalEntry(date: Date(), title: "", text: "")
                }else{
                    newEntry = nil
                }
            }
        }else{
            // Fallback on earlier versions
        }
    }
}
