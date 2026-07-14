import SwiftUI

struct StarRatingView: View {
    let rating: Int
    var interactive: Bool = false
    var size: CGFloat = 14
    var color: Color = .yellow
    var onRatingChange: ((Int) -> Void)?

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundStyle(star <= rating ? color : Color.white.opacity(0.25))
                    .frame(minWidth: interactive ? 28 : nil, minHeight: interactive ? 28 : nil)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if interactive {
                            onRatingChange?(star)
                        }
                    }
            }
        }
    }
}
