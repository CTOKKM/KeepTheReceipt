import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AddReceiptView()
                .tabItem {
                    Label("등록/촬영", image: "addIcon")
                }
                .tag(0)
            
            HomeView()
                .tabItem {
                    Label("홈", image: "homeIcon")
                }
                .tag(1)
            
            AnalysisView()
                .tabItem {
                    Label("분석", image: "analIcon")
                }
                .tag(2)
        }
        .accentColor(Color(hex: "032E6E"))
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = UIColor(named: "UnselectedTabColor")
        }
    }
}

#Preview {
    MainTabView()
} 