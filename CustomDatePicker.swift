import SwiftUI

struct CustomDatePicker: View{
    @Binding var selectedDate: Date
    @Binding var isNightMode: Bool
    var body: some View{
        VStack{
            DatePicker(
                "",
                selection: $selectedDate,
                in: ...Date(),
                displayedComponents: .date
            )
            .labelsHidden()
            .padding(1)
            .cornerRadius(8)
            .background(isNightMode ? Color.white : Color.white)
            .foregroundColor(isNightMode ? .white : .black)
            .cornerRadius(8)
            
        }
    }
}

