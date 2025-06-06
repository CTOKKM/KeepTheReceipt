import Foundation
import UIKit

struct Receipt: Identifiable {
    let id = UUID()
    let storeName: String
    let totalAmount: Double
    let date: Date
    let category: String
    let memo: String
    let image: UIImage?
    
    // 영수증 텍스트 파싱을 위한 정규식 패턴
    static let patterns = [
        "storeName": #"^.*?(?=\s*\d{2}:\d{2}|\s*영수증|\s*주문번호)"#,
        "date": #"\d{4}[-/년]\s*\d{1,2}[-/월]\s*\d{1,2}일?"#,
        "amount": #"합\s*계\s*:?\s*(\d{1,3}(?:,\d{3})*)원"#,
        "time": #"\d{2}:\d{2}"#
    ]
} 
