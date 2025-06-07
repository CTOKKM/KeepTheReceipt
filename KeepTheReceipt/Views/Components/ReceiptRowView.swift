import SwiftUI

struct ReceiptRowView: View {
    let receipt: Receipt
    var isSelected: Bool = false
    
    var body: some View {
        HStack {
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(ColorTheme.primary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(receipt.storeName)
                        .font(.headline)
                    Spacer()
                    Text("₩\(Int(receipt.amount))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
                
                HStack {
                    Text(receipt.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(receipt.category)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(ColorTheme.getColor(for: receipt.category))
                        )
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 16) {
        ReceiptRowView(receipt: Receipt(
            storeName: "테스트 가게",
            date: Date(),
            amount: 15000,
            category: "식비"
        ))
        ReceiptRowView(receipt: Receipt(
            storeName: "테스트 가게",
            date: Date(),
            amount: 15000,
            category: "교통비"
        ))
        ReceiptRowView(receipt: Receipt(
            storeName: "테스트 가게",
            date: Date(),
            amount: 15000,
            category: "쇼핑"
        ))
        ReceiptRowView(receipt: Receipt(
            storeName: "테스트 가게",
            date: Date(),
            amount: 15000,
            category: "생활비"
        ))
        ReceiptRowView(receipt: Receipt(
            storeName: "테스트 가게",
            date: Date(),
            amount: 15000,
            category: "기타"
        ))
    }
    .padding()
    .background(Color(hex: "f2f2f2"))
} 
