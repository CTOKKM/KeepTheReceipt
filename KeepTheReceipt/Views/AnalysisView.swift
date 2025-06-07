import SwiftUI
import Charts

struct AnalysisView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    
    // 차트 색상
    let chartColors: [Color] = [
        Color(hex: "032E6E"),  // 메인 컬러
        Color(hex: "1A4B8C"),  // 약간 밝은 파란색
        Color(hex: "3366AA"),  // 중간 톤의 파란색
        Color(hex: "4D7FC7"),  // 밝은 파란색
        Color(hex: "6699E0")   // 가장 밝은 파란색
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 날짜 선택
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
                    
                    // 도넛 차트
                    VStack(spacing: 16) {
                        Text("카테고리별 지출")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 20) {
                            Chart {
                                ForEach(Array(viewModel.categoryData.enumerated()), id: \.element.0) { index, data in
                                    SectorMark(
                                        angle: .value("금액", data.1),
                                        innerRadius: .ratio(0.618),
                                        angularInset: 1.5
                                    )
                                    .foregroundStyle(chartColors[index % chartColors.count])
                                    .annotation(position: .overlay) {
                                        Text(data.0)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .frame(height: 200)
                            
                            // 범례
                            VStack(spacing: 8) {
                                ForEach(Array(viewModel.categoryData.enumerated()), id: \.element.0) { index, data in
                                    HStack {
                                        Circle()
                                            .fill(chartColors[index % chartColors.count])
                                            .frame(width: 12, height: 12)
                                        
                                        Text(data.0)
                                            .font(.system(size: 14))
                                        
                                        Spacer()
                                        
                                        Text("₩\(Int(data.1))")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(chartColors[index % chartColors.count])
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    
                    // 막대 차트
                    VStack(spacing: 16) {
                        Text("일별 지출 추이")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Chart {
                            ForEach(viewModel.dailyData, id: \.0) { day, amount in
                                BarMark(
                                    x: .value("날짜", day),
                                    y: .value("금액", amount)
                                )
                                .foregroundStyle(chartColors[0].gradient)
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                        .chartXAxis {
                            AxisMarks(values: .automatic) { _ in
                                AxisValueLabel()
                            }
                        }
                        .frame(height: 200)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.horizontal, 24)
                    
                    // 카테고리별 상세 내역
                    VStack(spacing: 16) {
                        Text("카테고리별 상세 내역")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 12) {
                            ForEach(Array(viewModel.categoryData.enumerated()), id: \.element.0) { index, data in
                                HStack {
                                    Text(data.0)
                                        .font(.system(size: 14, weight: .medium))
                                    
                                    Spacer()
                                    
                                    Text("₩\(Int(data.1))")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(chartColors[index % chartColors.count])
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 24)
            }
            .background(Color(hex: "f2f2f2"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("LogoIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24)
                }
            }
            .task {
                await viewModel.fetchData()
            }
        }
    }
}

#Preview {
    AnalysisView()
} 
 