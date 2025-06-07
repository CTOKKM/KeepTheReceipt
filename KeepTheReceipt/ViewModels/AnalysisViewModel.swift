import Foundation
import FirebaseFirestore

@MainActor
class AnalysisViewModel: ObservableObject {
    @Published var receipts: [Receipt] = []
    @Published var categoryData: [(String, Double)] = []
    @Published var dailyData: [(String, Double)] = []
    
    private let firebaseService = FirebaseService.shared
    
    func fetchData() async {
        do {
            let allReceipts = try await firebaseService.fetchReceipts()
            self.receipts = allReceipts
            
            // 카테고리별 지출 계산
            var categoryAmounts: [String: Double] = [:]
            for receipt in allReceipts {
                categoryAmounts[receipt.category, default: 0] += receipt.amount
            }
            
            self.categoryData = categoryAmounts.map { ($0.key, $0.value) }
                .sorted { $0.1 > $1.1 }
            
            // 일별 지출 계산
            let calendar = Calendar.current
            var dailyAmounts: [(Int, Double)] = []
            
            for receipt in allReceipts {
                let day = calendar.component(.day, from: receipt.date)
                dailyAmounts.append((day, receipt.amount))
            }
            
            // 일별로 그룹화하고 합산
            var groupedAmounts: [Int: Double] = [:]
            for (day, amount) in dailyAmounts {
                groupedAmounts[day, default: 0] += amount
            }
            
            // 정렬된 결과 생성
            self.dailyData = groupedAmounts
                .sorted { $0.key < $1.key }
                .map { ("\($0.key)일", $0.value) }
            
        } catch {
            print("Error fetching receipts: \(error)")
        }
    }
} 