import SwiftUI

extension View{
    func textFieldPlaceholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View{
        ZStack(alignment: alignment){
            self
            if shouldShow{
                placeholder()
                    .foregroundColor(.gray)
            }
        }
    }
}

extension View{
    func textEditorPlaceholder<Content: View>(
        when shouldShow: Bool,
        @ViewBuilder placeholder: () -> Content
    ) -> some View{
        ZStack(alignment: .topLeading){
            self
            if shouldShow{
                placeholder()
                    .padding(.top, 8)
                    .padding(.leading, 5)
                    .foregroundColor(.gray)
            }
        }
    }
}
