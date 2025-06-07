import SwiftUI
import Charts

struct HomeView: View {
    @Binding var showingAddReceipt: Bool
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Image("LogoIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    
                    HStack {
                        Text("2025년 5월")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            // 총 지출 금액 카드
                            TotalExpenseCard(totalAmount: viewModel.totalAmount)
                            
                            // 카테고리별 지출 차트
                            CategoryExpenseChart(categoryData: viewModel.categoryData)
                            
                            // 최근 지출 내역
                            LatestExpenseView(receipts: viewModel.recentReceipts)
                        }
                        .padding()
                    }
                }
                .background((Color(hex: "f2f2f2")))
                
                // 플로팅 버튼
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddReceiptButton(showingAddReceipt: $showingAddReceipt)
                            .padding(.trailing, 24)
                            .padding(.bottom, 24)
                    }
                }
            }
            .task {
                await viewModel.fetchData()
            }
        }
    }
}

struct TotalExpenseCard: View {
    let totalAmount: Double
    private let monthlyGoal: Double = 1_000_000 // 월 목표 지출 금액
    
    private var progressPercentage: Double {
        min(totalAmount / monthlyGoal, 1.0)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("이번 달 총 지출 금액")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            
            HStack {
                Text("₩\(Int(totalAmount))")
                    .font(.system(size: 16, weight: .light))
                    .foregroundStyle((Color(hex: "96A7BE")))
                Spacer()
            }
            
            // 프로그레스바
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: "E8E8E8"))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ColorTheme.primary)
                        .frame(width: geometry.size.width * progressPercentage, height: 8)
                }
            }
            .frame(height: 8)
            
            HStack {
                Text("\(Int(progressPercentage * 100))%")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.main)
                
                Spacer()
                
                Text("목표: ₩\(Int(monthlyGoal))")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "96A7BE"))
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white)
        .cornerRadius(12)
    }
}

struct CategoryExpenseChart: View {
    let categoryData: [(String, Double)]
    
    private var maxAmount: Double {
        categoryData.first?.1 ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("최대 소비 카테고리")
                .font(.system(size: 18, weight: .bold))
            
            VStack(spacing: 12) {
                ForEach(categoryData.prefix(4), id: \.0) { category, amount in
                    CategoryProgressRow(category: category, amount: amount, maxAmount: maxAmount)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct CategoryProgressRow: View {
    let category: String
    let amount: Double
    let maxAmount: Double
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("₩\(Int(amount))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(hex: "f2f2f2"))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(ColorTheme.getColor(for: category))
                        .frame(width: geometry.size.width * CGFloat(amount / maxAmount), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

struct LatestExpenseView: View {
    let receipts: [Receipt]
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("최근 지출 내역")
                .font(.system(size: 18, weight: .bold))
            
            if receipts.isEmpty {
                Text("아직 등록된 영수증이 없습니다")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "96A7BE"))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(receipts) { receipt in
                    ReceiptRowView(receipt: receipt)
                }
            }
        }
        .padding(.bottom, 80)
    }
}

struct AddReceiptButton: View {
    @Binding var showingAddReceipt: Bool
    
    var body: some View {
        Button(action: {
            showingAddReceipt = true
        }) {
            Image("addIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(16)
                .background(ColorTheme.primary)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    HomeView(showingAddReceipt: .constant(false))
} 
