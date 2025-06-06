import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("홈", systemImage: "house")
                }
                .tag(0)
            
            AddReceiptView()
                .tabItem {
                    Label("등록", systemImage: "plus.circle")
                }
                .tag(1)
            
            AnalysisView()
                .tabItem {
                    Label("분석", systemImage: "chart.bar")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("설정", systemImage: "gear")
                }
                .tag(3)
        }
        .accentColor(Color(hex: "032E6E"))
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = UIColor(named: "UnselectedTabColor")
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        HStack {
                            Text("로그아웃")
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: "arrow.right.square")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("설정")
        }
    }
}

#Preview {
    MainTabView()
} 