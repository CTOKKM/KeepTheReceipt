import Foundation

struct ParsedReceiptData {
    let storeName: String
    let date: Date
}

class ReceiptParserService {
    static func parseReceiptText(_ text: String) -> ParsedReceiptData? {
        print("📝 영수증 파싱 시작...")
        print("원본 텍스트: \(text.prefix(200))...")
        
        // 가게 이름 찾기 (첫 줄에서 추출)
        let storeName = extractStoreName(from: text)
        print("🏪 감지된 가게 이름: \(storeName ?? "찾을 수 없음")")
        
        // 날짜 찾기 (여러 형식 시도)
        let date = extractDate(from: text)
        print("📅 감지된 날짜: \(date?.description ?? "찾을 수 없음")")
        
        // 필수 정보가 없어도 기본값으로 처리
        let finalStoreName = storeName ?? "알 수 없는 가게"
        let finalDate = date ?? Date()
        
        print("✅ 영수증 데이터 파싱 완료")
        return ParsedReceiptData(
            storeName: finalStoreName,
            date: finalDate
        )
    }
    
    private static func extractStoreName(from text: String) -> String? {
        // 첫 줄에서 가게 이름 추출
        let lines = text.components(separatedBy: .newlines)
        if let firstLine = lines.first?.trimmingCharacters(in: .whitespacesAndNewlines) {
            // 불필요한 정보 제거
            let storeName = firstLine
                .replacingOccurrences(of: "사업자번호.*$", with: "", options: .regularExpression)
                .replacingOccurrences(of: "대표자.*$", with: "", options: .regularExpression)
                .replacingOccurrences(of: "전화.*$", with: "", options: .regularExpression)
                .replacingOccurrences(of: "주소.*$", with: "", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !storeName.isEmpty {
                return storeName
            }
        }
        return nil
    }
    
    private static func extractDate(from text: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        // 여러 날짜 형식 시도
        let datePatterns = [
            "yyyy년 MM월 dd일",
            "yyyy-MM-dd",
            "yyyy/MM/dd",
            "yy/MM/dd",
            "MM/dd/yyyy"
        ]
        
        for pattern in datePatterns {
            dateFormatter.dateFormat = pattern
            if let date = dateFormatter.date(from: text) {
                return date
            }
        }
        
        // 영수증 번호에서 날짜 추출 시도 (예: #20250527-10103)
        if let match = text.range(of: #"#(\d{8})"#, options: .regularExpression) {
            let dateString = String(text[match]).replacingOccurrences(of: "#", with: "")
            dateFormatter.dateFormat = "yyyyMMdd"
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        
        return nil
    }
} 