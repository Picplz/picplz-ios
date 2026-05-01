//
//  PicAlert.swift
//  Features
//
//  Created by wonsik on 4/7/26.
//

import SwiftUI

struct PicAlert: View {
    let title: String
    let message: String
    let cancelText: String
    let confirmText: String
    let onCancel: () -> Void
    let onConfirm: () -> Void

    init(
        title: String,
        message: String,
        cancelText: String = "취소",
        confirmText: String = "삭제",
        onCancel: @escaping () -> Void,
        onConfirm: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.cancelText = cancelText
        self.confirmText = confirmText
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text(title)
                        .typo(.pSmallTitle)
                        .foregroundStyle(.pBlack)

                    Text(message)
                        .typo(.pParagraph)
                        .foregroundStyle(.pGrey5)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 28)
                .padding(.bottom, 20)
                .padding(.horizontal, 16)

                Rectangle()
                    .fill(Color(.pGrey2))
                    .frame(height: 1)

                HStack(spacing: 0) {
                    Button {
                        onCancel()
                    } label: {
                        Text(cancelText)
                            .typo(.pButtonNormalLabel)
                            .foregroundStyle(.pBlack)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }


                    Button {
                        onConfirm()
                    } label: {
                        Text(confirmText)
                            .typo(.pButtonNormalLabel)
                            .foregroundStyle(.pWhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(.pBlack))
                    }
                }
            }
            .background(Color(.pWhite))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 40)
        }
    }
}

// MARK: - View Modifier

struct PicAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let cancelText: String
    let confirmText: String
    let onCancel: (() -> Void)?
    let onConfirm: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                PicAlert(
                    title: title,
                    message: message,
                    cancelText: cancelText,
                    confirmText: confirmText,
                    onCancel: {
                        isPresented = false
                        onCancel?()
                    },
                    onConfirm: {
                        isPresented = false
                        onConfirm()
                    }
                )
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: isPresented)
            }
        }
    }
}

extension View {
    func picAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        cancelText: String = "취소",
        confirmText: String = "삭제",
        onCancel: (() -> Void)? = nil,
        onConfirm: @escaping () -> Void
    ) -> some View {
        modifier(
            PicAlertModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                cancelText: cancelText,
                confirmText: confirmText,
                onCancel: onCancel,
                onConfirm: onConfirm
            )
        )
    }
}

#Preview {
    Color.white
        .picAlert(
            isPresented: .constant(true),
            title: "리뷰를 삭제하시겠습니까?",
            message: "삭제된 리뷰는\n되돌릴 수 없습니다.",
            onConfirm: {}
        )
}
