import Foundation
import UIKit
import FirebaseFirestore

struct Receipt: Identifiable, Codable {
    var id: String
    var storeName: String
    var date: Date
    var amount: Double
    var category: String
    var memo: String?
    var imageURL: String?
    var userId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case storeName
        case date
        case amount
        case category
        case memo
        case imageURL
        case userId
    }
    
    // 기본 초기화 메서드
    init(id: String = UUID().uuidString,
         storeName: String,
         date: Date,
         amount: Double,
         category: String,
         memo: String? = nil,
         imageURL: String? = nil,
         userId: String? = nil) {
        self.id = id
        self.storeName = storeName
        self.date = date
        self.amount = amount
        self.category = category
        self.memo = memo
        self.imageURL = imageURL
        self.userId = userId
    }
    
    // Firestore 문서를 Receipt로 변환하는 초기화 메서드
    init?(document: [String: Any]) {
        guard let id = document["id"] as? String,
              let storeName = document["storeName"] as? String,
              let amount = document["amount"] as? Double,
              let category = document["category"] as? String,
              let userId = document["userId"] as? String else {
            return nil
        }
        
        // Timestamp 또는 Date 처리
        if let timestamp = document["date"] as? Timestamp {
            self.date = timestamp.dateValue()
        } else if let date = document["date"] as? Date {
            self.date = date
        } else {
            return nil
        }
        
        self.id = id
        self.storeName = storeName
        self.amount = amount
        self.category = category
        self.memo = document["memo"] as? String
        self.imageURL = document["imageURL"] as? String
        self.userId = userId
    }
    
    // Receipt를 Firestore 문서로 변환하는 메서드
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "storeName": storeName,
            "date": Timestamp(date: date),
            "amount": amount,
            "category": category
        ]
        
        if let memo = memo {
            dict["memo"] = memo
        }
        
        if let imageURL = imageURL {
            dict["imageURL"] = imageURL
        }
        
        if let userId = userId {
            dict["userId"] = userId
        }
        
        return dict
    }
    
    // 영수증 텍스트 파싱을 위한 정규식 패턴
    static let patterns = [
        "storeName": #"^.*?(?=\s*\d{2}:\d{2}|\s*영수증|\s*주문번호)"#,
        "date": #"\d{4}[-/년]\s*\d{1,2}[-/월]\s*\d{1,2}일?"#,
        "amount": #"합\s*계\s*:?\s*(\d{1,3}(?:,\d{3})*)원"#,
        "time": #"\d{2}:\d{2}"#
    ]
    
    static func fromFirestore(_ document: QueryDocumentSnapshot) -> Receipt? {
        let data = document.data()
        
        guard let storeName = data["storeName"] as? String,
              let timestamp = data["date"] as? Timestamp,
              let amount = data["amount"] as? Double,
              let category = data["category"] as? String else {
            return nil
        }
        
        return Receipt(
            id: document.documentID,
            storeName: storeName,
            date: timestamp.dateValue(),
            amount: amount,
            category: category,
            memo: data["memo"] as? String,
            imageURL: data["imageURL"] as? String,
            userId: data["userId"] as? String
        )
    }
} 
