import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var selectedTab = 1
    @State private var showingAddReceipt = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AnalysisView()
                .tabItem {
                    Label("분석", systemImage: "chart.bar")
                }
                .tag(0)
            
            HomeView(showingAddReceipt: $showingAddReceipt)
                .environmentObject(homeViewModel)
                .tabItem {
                    Label("홈", systemImage: "house")
                }
                .tag(1)
            
            MyPageView()
                .tabItem {
                    Label("마이페이지", systemImage: "person")
                }
                .tag(2)
        }
        .accentColor(Color(hex: "019EDB"))
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = UIColor(named: "UnselectedTabColor")
        }
        .sheet(isPresented: $showingAddReceipt) {
            AddReceiptView(isPresented: $showingAddReceipt)
                .environmentObject(homeViewModel)
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
        .environmentObject(AuthViewModel())
} 
