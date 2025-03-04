import SwiftUI

struct MoodBoardView: View{
    @Binding var selectedTab: BottomNavBar.Tab
    @Binding var isNightMode: Bool
    @Binding var entries: [JournalEntry]
    @State private var selectedDate = Date()
    private let calendar = Calendar.current
    
    private var daysInMonth: [Date]{
        guard let range = calendar.range(of: .day, in: .month, for: selectedDate)else{
            return[]}
            return range.compactMap{day -> Date? in
            var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
            components.day = day
            return calendar.date(from: components)
        }
    }
    private var firstDayOfMonth: Int{
        guard let firstDay = daysInMonth.first else{return 1}
        return calendar.component(.weekday, from: firstDay)
    }
    
    private var currMonthImgs: [Data]{
        let calendar = Calendar.current
        let now = Date()
        return entries
            .filter{entry in
                calendar.isDate(entry.date, equalTo:now, toGranularity:.month)}
            .flatMap{$0.images}
    }
    
    var body: some View{
        VStack{
            HStack{
                Text("Mood Board")
                    .font(.custom("American Typewriter", size: 40))
                    .foregroundColor(isNightMode ? .white : .black)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
            MonthYearPicker(selectedDate: $selectedDate)
                .padding()
                .background(isNightMode ? Color.black : Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            ZStack{
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 8){
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self){
                        day in
                        Text(day)
                            .font(.caption)
                            .foregroundColor(isNightMode ? .gray : .black)
                            .frame(maxWidth: .infinity)
                    }
                    ForEach(0..<(firstDayOfMonth - 1), id: \.self) { _ in
                        Text("")
                            .frame(maxWidth: .infinity)
                    }
                    ForEach(daysInMonth, id: \.self){day in
                        if let entry = entries.first(where: {calendar.isDate($0.date, inSameDayAs: day)}),
                           let emoji = entry.emoji{
                            Text(emoji)
                                .font(.body)
                                .foregroundColor(isNightMode ? .white : .black)
                                .frame(maxWidth: .infinity)
                                .background(isNightMode ? Color.black : Color.white)
                                .cornerRadius(5)
                        }else{
                            Text("\(calendar.component(.day, from: day))")
                                .font(.body)
                                .foregroundColor(isNightMode ? .white : .black)
                                .frame(maxWidth: .infinity)
                                .background(isNightMode ? Color.black : Color.white)
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .padding()
            .padding()
            Text("Pictures of the Month")
                .font(.custom("American Typewriter", size: 30))
                .foregroundColor(isNightMode ? .white : .black)
            ScrollView{
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]){
                    ForEach(Array(currMonthImgs.enumerated()), id: \.offset){ _, imageData in
                        if let uiImage = UIImage(data: imageData){
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(1, contentMode:.fill)
                                .frame(width: 110, height: 110)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            
            Spacer()
        }
        .background(isNightMode ? Color.black : Color.white)
        .foregroundColor(isNightMode ? .white : .black)
        .navigationBarHidden(true)
    }
}
