import SwiftUI

struct AddReceiptView: View {
    @State private var showingCamera = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showingActionSheet = false
    @State private var storeName = ""
    @State private var totalAmount = ""
    @State private var date = Date()
    @State private var category = "식비"
    @State private var memo = ""
    @State private var isProcessing = false
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @FocusState private var isAmountFocused: Bool
    @Binding var isPresented: Bool
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    private let visionService = VisionService(apiKey: APIConfig.googleVisionAPIKey)
    
    let categories = ["식비", "교통비", "쇼핑", "생활비", "기타"]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // 사진 업로드 영역
                    VStack(spacing: 16) {
                        Text("영수증 사진")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {
                            showingActionSheet = true
                        }) {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 160)
                                    .clipped()
                                    .cornerRadius(12)
                            } else {
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
                        .disabled(isProcessing || isSaving)
                    }
                    .padding(.horizontal, 24)
                    
                    // 입력 폼
                    VStack(spacing: 24) {
                        CustomTextField(title: "가게 이름", text: $storeName, placeholder: "가게 이름을 입력하세요")
                        
                        CustomTextField(title: "금액", text: $totalAmount, placeholder: "금액을 입력하세요", keyboardType: .numberPad)
                            .focused($isAmountFocused)
                            .onChange(of: totalAmount) { newValue in
                                // 숫자만 남기고 모두 제거
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    totalAmount = filtered
                                }
                                
                                // 콤마 포맷팅
                                if let number = Int(filtered) {
                                    let formatter = NumberFormatter()
                                    formatter.numberStyle = .decimal
                                    if let formatted = formatter.string(from: NSNumber(value: number)) {
                                        totalAmount = formatted
                                    }
                                }
                            }
                        
                        // 날짜 선택
                        VStack(alignment: .leading, spacing: 8) {
                            Text("날짜")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(hex: "666666"))
                            
                            DatePicker("날짜 선택", selection: $date, displayedComponents: [.date])
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("카테고리")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(hex: "666666"))
                            
                            Picker("카테고리", selection: $category) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category).tag(category)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        CustomTextField(title: "메모", text: $memo, placeholder: "메모를 입력하세요")
                    }
                    .padding(.horizontal, 24)
                    
                    // 저장 버튼
                    Button(action: saveReceipt) {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("저장하기")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 50)
                    .background(isFormValid ? Color(hex: "032E6E") : Color.gray)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    .disabled(!isFormValid || isSaving)
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        isPresented = false
                    }
                }
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text("사진 선택"),
                    message: Text("영수증 사진을 어떻게 추가하시겠습니까?"),
                    buttons: [
                        .default(Text("카메라로 촬영")) {
                            showingCamera = true
                        },
                        .default(Text("앨범에서 선택")) {
                            showingImagePicker = true
                        },
                        .cancel(Text("취소"))
                    ]
                )
            }
            .sheet(isPresented: $showingCamera) {
                CameraView(image: $selectedImage)
                    .onDisappear {
                        if let image = selectedImage {
                            processImage(image)
                        }
                    }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
                    .onDisappear {
                        if let image = selectedImage {
                            processImage(image)
                        }
                    }
            }
            .overlay {
                if isProcessing {
                    ProgressView("영수증 정보 추출 중...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .alert("알림", isPresented: $showAlert) {
                Button("확인", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        !storeName.isEmpty && !totalAmount.isEmpty
    }
    
    private func saveReceipt() {
        guard let amount = Double(totalAmount.replacingOccurrences(of: ",", with: "")) else {
            alertMessage = "금액을 올바르게 입력해주세요."
            showAlert = true
            return
        }
        
        isSaving = true
        
        let receipt = Receipt(
            id: UUID().uuidString,
            storeName: storeName,
            date: date,
            amount: amount,
            category: category,
            memo: memo.isEmpty ? nil : memo,
            imageURL: nil,
            userId: FirebaseService.shared.currentUserId ?? ""
        )
        
        Task {
            do {
                try await FirebaseService.shared.saveReceipt(receipt, image: selectedImage)
                await MainActor.run {
                    isSaving = false
                    // HomeView 데이터 새로고침을 먼저 실행
                    Task {
                        await homeViewModel.fetchData()
                        // 데이터 새로고침이 완료된 후 모달 닫기
                        isPresented = false
                    }
                }
            } catch {
                await MainActor.run {
                    isSaving = false
                    alertMessage = "저장 중 오류가 발생했습니다: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
    
    private func processImage(_ image: UIImage) {
        isProcessing = true
        print("🔄 이미지 처리 시작...")
        
        Task {
            do {
                print("📤 Vision API로 이미지 전송 중...")
                let text = try await visionService.detectText(from: image)
                
                print("📥 Vision API에서 텍스트 수신, 파싱 시작...")
                if let parsedData = ReceiptParserService.parseReceiptText(text) {
                    await MainActor.run {
                        print("📝 파싱된 데이터로 폼 채우기:")
                        print("- 가게: \(parsedData.storeName)")
                        print("- 날짜: \(parsedData.date)")
                        
                        storeName = parsedData.storeName
                        date = parsedData.date
                        isAmountFocused = true  // 금액 입력 필드에 포커스
                    }
                } else {
                    print("⚠️ 영수증 데이터 파싱 실패")
                }
            } catch {
                print("❌ 이미지 처리 중 오류 발생: \(error)")
            }
            
            await MainActor.run {
                isProcessing = false
                print("✅ 이미지 처리 완료")
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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

#Preview {
    AddReceiptView(isPresented: .constant(true))
} 
