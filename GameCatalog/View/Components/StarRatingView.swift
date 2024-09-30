import SwiftUI

struct StarRatingView: View {
    let rating: Double
    private var fullStars: Int {
        return Int(rating)
    }
    private var halfStar: Bool {
        return rating.truncatingRemainder(dividingBy: 1) >= 0.5
    }
    private var emptyStars: Int {
        return 5 - fullStars - (halfStar ? 1 : 0)
    }
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<fullStars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            if halfStar {
                Image(systemName: "star.lefthalf.fill")
                    .foregroundColor(.yellow)
            }
            ForEach(0..<emptyStars, id: \.self) { _ in
                Image(systemName: "star")
                    .foregroundColor(.gray)
            }
        }
        .font(.system(size: 16))
    }
}

#Preview {
    StarRatingView(rating: 5.0)
}
