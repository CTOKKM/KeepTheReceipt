import SwiftUI
import Charts

struct HomeView: View {
    var body: some View {
        NavigationView {
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
                        TotalExpenseCard()
                        
                        // 카테고리별 지출 차트
                        CategoryExpenseChart()
                        
                        // 최근 지출 내역
                        LatestExpenseView()
                        
                        // 영수증 등록하기 버튼
                        AddReceiptButton()
                    }
                    .padding()
                }
            }
            .background((Color(hex: "f2f2f2")))
        }
    }
}

struct TotalExpenseCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("이번 달 총 지출 금액")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            
            HStack {
                Text("₩0")
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
                        .fill(Color(hex: "032E6E"))
                        .frame(width: geometry.size.width * 0.3, height: 8)
                }
            }
            .frame(height: 8)
            
            HStack {
                Text("30%")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "032E6E"))
                
                Spacer()
                
                Text("목표: ₩1,000,000")
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
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("최대 소비 카테고리")
                .font(.system(size: 18, weight: .bold))
            
            VStack(spacing: 12) {
                ForEach(0..<4) { _ in
                    VStack(spacing: 4) {
                        HStack {
                            Text("카테고리")
                                .font(.system(size: 14, weight: .medium))
                            
                            Spacer()
                            
                            Text("₩0")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "96A7BE"))
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(hex: "E8E8E8"))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(hex: "032E6E"))
                                    .frame(width: geometry.size.width * 0.5, height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct LatestExpenseView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("최근 지출 내역")
                .font(.system(size: 18, weight: .bold))
            
            Text("아직 등록된 영수증이 없습니다")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "96A7BE"))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
        }
    }
}

struct AddReceiptButton: View {
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 24) {
                Image("addIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45)
                    .foregroundStyle(Color(hex:"032E6E"))
                
                Text("영수증 등록하러 가기")
                    .font(.system(size: 24, weight: .bold))
                    .lineLimit(1)
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    HomeView()
} 
