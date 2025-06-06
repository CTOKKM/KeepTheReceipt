import SwiftUI

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // 배경 그라데이션
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "032E6E"), Color(hex: "1E90FF")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        // 앱 로고
                        Image("LogoIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .padding(.top, 50)
                            .padding(.horizontal, 24)
                        
                        // 입력 폼
                        VStack(spacing: 20) {
                            // 이메일 입력
                            VStack(alignment: .leading, spacing: 8) {
                                Text("이메일")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                
                                TextField("", text: $email)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .textContentType(.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .focused($focusedField, equals: .email)
                            }
                            
                            // 비밀번호 입력
                            VStack(alignment: .leading, spacing: 8) {
                                Text("비밀번호")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                
                                SecureField("", text: $password)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .textContentType(isSignUp ? .newPassword : .password)
                                    .focused($focusedField, equals: .password)
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 30)
                        
                        // 로그인/회원가입 버튼
                        Button(action: {
                            hideKeyboard()
                            isLoading = true
                            Task {
                                do {
                                    if isSignUp {
                                        try await FirebaseService.shared.signUp(email: email, password: password)
                                    } else {
                                        try await FirebaseService.shared.signIn(email: email, password: password)
                                    }
                                } catch {
                                    alertMessage = error.localizedDescription
                                    showAlert = true
                                }
                                isLoading = false
                            }
                        }) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text(isSignUp ? "회원가입" : "로그인")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.2))
                        )
                        .padding(.horizontal, 30)
                        .disabled(email.isEmpty || password.isEmpty || isLoading)
                        
                        // 로그인/회원가입 전환 버튼
                        Button(action: {
                            withAnimation {
                                isSignUp.toggle()
                                email = ""
                                password = ""
                            }
                        }) {
                            Text(isSignUp ? "이미 계정이 있으신가요? 로그인" : "계정이 없으신가요? 회원가입")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.subheadline)
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                }
            }
            .alert("알림", isPresented: $showAlert) {
                Button("확인", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func hideKeyboard() {
        focusedField = nil
    }
}

// 커스텀 텍스트필드 스타일
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.15))
            .cornerRadius(12)
            .foregroundColor(.white)
            .accentColor(.white)
    }
}

#Preview {
    AuthView()
}
