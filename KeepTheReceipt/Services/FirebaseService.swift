import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class FirebaseService {
    static let shared = FirebaseService()
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
    
    private init() {}
    
    // MARK: - Authentication
    func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }
    
    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Receipt Management
    func saveReceipt(_ receipt: Receipt, image: UIImage?) async throws {
        guard let userId = currentUserId else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "사용자 인증 필요"])
        }
        
        // 1. 이미지가 있다면 Storage에 업로드
        var imageURL: String?
        if let image = image {
            imageURL = try await uploadImage(image)
        }
        
        // 2. 영수증 데이터 저장
        var receiptData = receipt
        receiptData.imageURL = imageURL
        receiptData.userId = userId
        
        try await db.collection("receipts").document(receipt.id).setData(receiptData.toDictionary())
    }
    
    private func uploadImage(_ image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "이미지 변환 실패"])
        }
        
        let filename = "\(UUID().uuidString).jpg"
        let storageRef = storage.reference().child("receipts/\(filename)")
        
        let _ = try await storageRef.putDataAsync(imageData)
        let url = try await storageRef.downloadURL()
        return url.absoluteString
    }
    
    func fetchReceipts() async throws -> [Receipt] {
        guard let userId = currentUserId else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "사용자 인증 필요"])
        }
        
        let snapshot = try await db.collection("receipts")
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            Receipt(document: document.data())
        }
    }
    
    func deleteReceipt(_ receipt: Receipt) async throws {
        // 1. 이미지가 있다면 Storage에서 삭제
        if let imageURL = receipt.imageURL {
            let storageRef = storage.reference(forURL: imageURL)
            try await storageRef.delete()
        }
        
        // 2. Firestore에서 문서 삭제
        try await db.collection("receipts").document(receipt.id).delete()
    }
} 