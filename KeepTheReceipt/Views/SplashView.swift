import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if isActive {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(authViewModel)
            } else {
                AuthView()
                    .environmentObject(authViewModel)
            }
        } else {
            ZStack {
                // 배경 그라데이션
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "032E6E"), Color(hex: "019EDB")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // 앱 로고
                    Image("LogoIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .padding(.horizontal, 24)
                    
                    Image("LogoIcon 1")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .padding(.bottom, 150)
                    
                    HStack(spacing: 0) {
                        Text("영")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("수증 ")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex:"#e2e2e2"))
                        
                        Text("버")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("리지 ")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex:"#e2e2e2"))

                        Text("마")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AuthViewModel())
} 
