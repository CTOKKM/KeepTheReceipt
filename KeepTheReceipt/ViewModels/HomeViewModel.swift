import Foundation
import FirebaseFirestore

@MainActor
class HomeViewModel: ObservableObject {
    @Published var receipts: [Receipt] = []
    @Published var totalAmount: Double = 0
    @Published var categoryData: [(String, Double)] = []
    @Published var recentReceipts: [Receipt] = []
    
    private let firebaseService = FirebaseService.shared
    
    func fetchData() async {
        do {
            let allReceipts = try await firebaseService.fetchReceipts()
            self.receipts = allReceipts
            
            // 총 지출 금액 계산
            self.totalAmount = allReceipts.reduce(0) { $0 + $1.amount }
            
            // 카테고리별 지출 계산
            var categoryAmounts: [String: Double] = [:]
            for receipt in allReceipts {
                categoryAmounts[receipt.category, default: 0] += receipt.amount
            }
            
            self.categoryData = categoryAmounts.map { ($0.key, $0.value) }
                .sorted { $0.1 > $1.1 }
            
            // 최근 지출 내역 (최근 5개)
            self.recentReceipts = Array(allReceipts.prefix(5))
            
        } catch {
            print("Error fetching receipts: \(error)")
        }
    }
} 