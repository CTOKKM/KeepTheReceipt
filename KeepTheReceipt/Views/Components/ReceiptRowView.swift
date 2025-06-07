import SwiftUI

struct ReceiptRowView: View {
    let receipt: Receipt
    var isSelected: Bool = false
    
    var body: some View {
        HStack {
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(hex: "032E6E"))
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
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
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
    ReceiptRowView(receipt: Receipt(
        storeName: "테스트 가게",
        date: Date(),
        amount: 15000,
        category: "식비"
    ))
} 
