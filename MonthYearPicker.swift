import SwiftUI

struct MonthYearPicker: View{
    @Binding var selectedDate: Date
    private let calendar = Calendar.current
    private var months: [String]{
        return calendar.monthSymbols
    }
    private var years: [Int]{
        let currYear = calendar.component(.year, from: Date())
        return Array((currYear - 20)...(currYear))
    }
    
    @State private var selectedMonth: Int
    @State private var selectedYear: Int
    init(selectedDate: Binding<Date>){
        self._selectedDate = selectedDate
        let components = calendar.dateComponents([.year, .month], from: selectedDate.wrappedValue)
        self._selectedMonth = State(initialValue: components.month ?? 1)
        self._selectedYear = State(initialValue: components.year ?? calendar.component(.year, from: Date()))
    }
    
    var body: some View{
        HStack{
            Picker("Month", selection: $selectedMonth){
                ForEach(1...12, id: \.self){
                    month in
                    Text(months[month - 1]).tag(month)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Picker("Year", selection: $selectedYear){
                ForEach(years, id: \.self){
                    year in
                    Text(String(year)).tag(year)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .onChange(of: selectedMonth){
            _ in updateSelectedDate()
        }
        .onChange(of: selectedYear){
            _ in updateSelectedDate()
        }
    }
    
    private func updateSelectedDate(){
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        components.year = selectedYear
        components.month = selectedMonth
        components.day = 1
        selectedDate = calendar.date(from: components) ?? Date()
    }
}
