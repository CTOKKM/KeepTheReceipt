import Foundation
import UIKit

class VisionService {
    private let apiKey: String
    private let baseURL = "https://vision.googleapis.com/v1/images:annotate"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func detectText(from image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ 이미지를 JPEG 데이터로 변환하는데 실패했습니다")
            throw VisionError.imageConversionFailed
        }
        
        let base64Image = imageData.base64EncodedString()
        
        let requestBody: [String: Any] = [
            "requests": [
                [
                    "image": [
                        "content": base64Image
                    ],
                    "features": [
                        [
                            "type": "TEXT_DETECTION",
                            "maxResults": 10
                        ]
                    ]
                ]
            ]
        ]
        
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            print("❌ 잘못된 URL입니다")
            throw VisionError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("❌ 요청 데이터 직렬화에 실패했습니다: \(error)")
            throw VisionError.requestSerializationFailed
        }
        
        print("📤 Vision API로 요청을 보내는 중...")
        print("URL: \(url)")
        print("API Key: \(apiKey.prefix(5))...")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ 잘못된 HTTP 응답입니다")
            throw VisionError.invalidResponse
        }
        
        print("📥 응답 수신 (상태 코드: \(httpResponse.statusCode))")
        
        if httpResponse.statusCode != 200 {
            if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("❌ API 오류: \(errorJson)")
            }
            throw VisionError.apiError(statusCode: httpResponse.statusCode)
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let responses = json["responses"] as? [[String: Any]],
              let firstResponse = responses.first,
              let textAnnotations = firstResponse["textAnnotations"] as? [[String: Any]],
              let firstAnnotation = textAnnotations.first,
              let detectedText = firstAnnotation["description"] as? String else {
            print("❌ 응답 파싱에 실패했습니다: \(String(data: data, encoding: .utf8) ?? "데이터 없음")")
            throw VisionError.parsingFailed
        }
        
        print("✅ 텍스트 감지 성공: \(detectedText.prefix(100))...")
        return detectedText
    }
}

// MARK: - Models
struct VisionResponse: Codable {
    let responses: [VisionResponseItem]
}

struct VisionResponseItem: Codable {
    let textAnnotations: [TextAnnotation]
}

struct TextAnnotation: Codable {
    let description: String
}

// MARK: - Errors
enum VisionError: Error {
    case imageConversionFailed
    case invalidURL
    case requestSerializationFailed
    case invalidResponse
    case apiError(statusCode: Int)
    case parsingFailed
} 