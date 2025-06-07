import SwiftUI

struct MyPageView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isSelectionMode = false
    @State private var selectedReceipts: Set<String> = []
    @State private var showingDeleteAlert = false
    @State private var showingLogoutAlert = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // 상단 헤더
                    HStack {
                        Image("LogoIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24)
                        
                        Spacer()
                        
                        if !viewModel.receipts.isEmpty {
                            Button(action: {
                                isSelectionMode.toggle()
                                if !isSelectionMode {
                                    selectedReceipts.removeAll()
                                }
                            }) {
                                Text(isSelectionMode ? "취소" : "선택")
                                    .foregroundColor(Color(hex: "032E6E"))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    if viewModel.receipts.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(Color(hex: "96A7BE"))
                            
                            Text("등록된 영수증이 없습니다")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "96A7BE"))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(viewModel.receipts) { receipt in
                                ReceiptRowView(receipt: receipt, isSelected: selectedReceipts.contains(receipt.id))
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        if isSelectionMode {
                                            if selectedReceipts.contains(receipt.id) {
                                                selectedReceipts.remove(receipt.id)
                                            } else {
                                                selectedReceipts.insert(receipt.id)
                                            }
                                        }
                                    }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    
                    Spacer()
                    
                    // 로그아웃 버튼
                    Button(action: {
                        showingLogoutAlert = true
                    }) {
                        Text("로그아웃")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "96A7BE"))
                            .padding(.vertical, 8)
                    }
                    .padding(.bottom, 16)
                }
            }
            .background(Color(hex: "f2f2f2"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isSelectionMode && !selectedReceipts.isEmpty {
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            Text("삭제")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .alert("선택한 영수증을 삭제하시겠습니까?", isPresented: $showingDeleteAlert) {
                Button("취소", role: .cancel) { }
                Button("삭제", role: .destructive) {
                    deleteSelectedReceipts()
                }
            }
            .alert("로그아웃", isPresented: $showingLogoutAlert) {
                Button("취소", role: .cancel) { }
                Button("로그아웃", role: .destructive) {
                    do {
                        try authViewModel.signOut()
                    } catch {
                        print("Error signing out: \(error)")
                    }
                }
            } message: {
                Text("로그아웃 하시겠습니까?")
            }
            .task {
                await viewModel.fetchData()
            }
        }
    }
    
    private func deleteSelectedReceipts() {
        Task {
            for receiptId in selectedReceipts {
                if let receipt = viewModel.receipts.first(where: { $0.id == receiptId }) {
                    do {
                        try await FirebaseService.shared.deleteReceipt(receipt)
                    } catch {
                        print("Error deleting receipt: \(error)")
                    }
                }
            }
            selectedReceipts.removeAll()
            isSelectionMode = false
            await viewModel.fetchData()
        }
    }
}

#Preview {
    MyPageView()
        .environmentObject(AuthViewModel())
} 
