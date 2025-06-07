import SwiftUI

struct ColorTheme {
    static let main = Color(hex: "032E6E")
    static let primary = Color(hex: "019EDB")
    static let secondary = Color(hex: "53BFE9")
    static let tertiary = Color(hex: "5C8C9E")
    static let quaternary = Color(hex: "98BAC8")
    
    static let categoryColors: [String: Color] = [
        "식비": main,
        "교통비": primary,
        "쇼핑": secondary,
        "생활비": tertiary,
        "기타": quaternary
    ]
    
    static func getColor(for category: String) -> Color {
        return categoryColors[category] ?? main
    }
} 