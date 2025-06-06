import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            self?.isAuthenticated = user != nil
        }
    }
    
    func signOut() {
        do {
            try FirebaseService.shared.signOut()
        } catch {
            print("로그아웃 실패: \(error.localizedDescription)")
        }
    }
} 