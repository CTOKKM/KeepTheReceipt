import Foundation

enum APIConfig {
    // Google Cloud Vision API 키
    static let googleVisionAPIKey = "AIzaSyBVZObRlvKtAhqAnxX8fWE2JiB_rsTM5zQ"
    
    // API 엔드포인트
    static let visionAPIEndpoint = "https://vision.googleapis.com/v1/images:annotate"
    
    // API 요청 헤더
    static let headers: [String: String] = [
        "Content-Type": "application/json"
    ]
} 
