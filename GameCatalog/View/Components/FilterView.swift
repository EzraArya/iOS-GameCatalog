import SwiftUI

struct FilterView: View {
    let buttonIcon: String
    let action: () -> Void
    let isSelected: Bool
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: buttonIcon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? Color.white : Color.black)
                .padding(10)
                .background(isSelected ? Color.black : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 2)
                )
                .padding(5)
                .shadow(radius: 1)
        })
    }
}
