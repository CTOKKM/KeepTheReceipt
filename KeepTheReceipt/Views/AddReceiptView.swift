import SwiftUI

struct AddReceiptView: View {
    @State private var showingCamera = false
    @State private var showingImagePicker = false
    @State private var storeName = ""
    @State private var totalAmount = ""
    @State private var date = Date()
    @State private var category = "식비"
    @State private var memo = ""
    
    let categories = ["식비", "교통비", "쇼핑", "생활비", "기타"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 날짜 선택
                    HStack {
                        Text("2025년 5월")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    
                    // 사진 업로드 영역
                    VStack(spacing: 16) {
                        Text("영수증 사진")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {
                            // 카메라/앨범 선택 메뉴 표시
                            showingCamera = true
                        }) {
                            VStack(spacing: 12) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(Color(hex: "032E6E"))
                                
                                Text("사진 업로드하기")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(hex: "032E6E"))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 160)
                            .background(Color(hex: "F5F5F5"))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // 영수증 정보 입력 영역
                    VStack(spacing: 24) {
                        Text("영수증 정보")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 20) {
                            // 상점명
                            CustomTextField(title: "상점명", text: $storeName, placeholder: "상점명을 입력하세요")
                            
                            // 금액
                            CustomTextField(title: "금액", text: $totalAmount, placeholder: "금액을 입력하세요", keyboardType: .numberPad)
                            
                            // 날짜
                            VStack(alignment: .leading, spacing: 8) {
                                Text("날짜")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: "666666"))
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
//                                    .background(Color(hex: "F5F5F5"))
                                    .cornerRadius(8)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            
                            // 카테고리
                            VStack(alignment: .leading, spacing: 8) {
                                Text("카테고리")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: "666666"))
                                Picker("카테고리", selection: $category) {
                                    ForEach(categories, id: \.self) { category in
                                        Text(category).tag(category)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(hex: "F5F5F5"))
                                .cornerRadius(8)
                            }
                            
                            // 메모
                            VStack(alignment: .leading, spacing: 8) {
                                Text("메모")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: "666666"))
                                TextEditor(text: $memo)
                                    .frame(height: 100)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(hex: "E8E8E8"), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // 저장 버튼
                    Button(action: {
                        // 저장 로직
                    }) {
                        Text("저장하기")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(hex: "032E6E"))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                }
                .padding(.vertical, 24)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("LogoIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24)
                }
            }
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "666666"))
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(hex: "F5F5F5"))
                .cornerRadius(8)
        }
    }
}

struct ReceiptRowView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("상점명")
                    .font(.headline)
                Spacer()
                Text("₩0")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("날짜")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("카테고리")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AddReceiptView()
} 
