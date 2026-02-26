//
//  AppTextField.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import SwiftUI
import SwiftNavigation

struct AppTextField: View {
    @FocusState private var focused: Bool
    @Binding var text: String
    @Binding var isFocused: Bool
    
    let title: String?
    let placeholder: String
    let hidePlaceholderOnFocus: Bool
    let disabled: Bool
    let hasClearButton: Bool
    let isSecureField: Bool
    
    private var state: State {
        guard disabled == false else {
            return .disabled
        }
        
        return focused ? .focused : .default
    }
    
    private var isPlaceholderHidden: Bool {
        hidePlaceholderOnFocus && focused
    }
    
    init(
        text: Binding<String>,
        isFocused: Binding<Bool>,
        title: String? = nil,
        placeholder: String = "",
        hidePlaceholderOnFocus: Bool = false,
        disabled: Bool = false,
        hasClearButton: Bool = true,
        isSecureField: Bool = false
    ) {
        self._text = text
        self._isFocused = isFocused
        self.title = title
        self.placeholder = placeholder
        self.hidePlaceholderOnFocus = hidePlaceholderOnFocus
        self.disabled = disabled
        self.hasClearButton = hasClearButton
        self.isSecureField = isSecureField
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            titleLabel
            textFieldBlock
        }
    }
    
    @ViewBuilder
    private var titleLabel: some View {
        if let title {
            Text(title)
                .appFont(
                    .p2SemiBold,
                    appColor: .gray60
                )
        }
    }
    
    @ViewBuilder
    private var textFieldBlock: some View {
        HStack(spacing: 0) {
            textField
            clearButton
        }
        .padding(textFieldBlockEdgeInsets)
        .background {
            textFieldShape
        }
    }
    
    private var textField: some View {
        inputField
        .textInputAutocapitalization(.never)
        .focused($focused)
        .bind(
            $isFocused,
            to: $focused
        )
        .lineLimit(1)
        .appFont(
            .p1Regular,
            appColor: textColor
        )
        .disabled(disabled)
    }
    
    @ViewBuilder
    private var inputField: some View {
        if isSecureField {
            SecureField(
                isPlaceholderHidden ? "" : placeholder,
                text: $text
            )
        } else {
            TextField(
                isPlaceholderHidden ? "" : placeholder,
                text: $text
            )
        }
    }
    
    @ViewBuilder
    private var clearButton: some View {
        if focused && !text.isEmpty && hasClearButton {
            Button {
                text = ""
            } label: {
                AppIcon.delete.image(
                    size: 20,
                    appColor: .gray60
                )
            }
        }
    }
    
    private var textFieldShape: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(backgroundColor.color)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        borderlineColor.color,
                        lineWidth: 1
                    )
            }
    }
}

// MARK: UI Properties
extension AppTextField {
    private var textFieldBlockEdgeInsets: EdgeInsets {
        EdgeInsets(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
    }
    
    private var backgroundColor: AppColor {
        switch state {
        case .default:
                .white
        case .focused:
                .lavender20
        case .disabled:
                .gray20
        }
    }
    
    private var borderlineColor: AppColor {
        switch state {
        case .focused:
                .primary40
        default:
                .gray20
        }
    }
    
    private var textColor: AppColor {
        switch state {
        case .disabled:
                .gray50
        default:
                .black
        }
    }
}

// MARK: Types
extension AppTextField {
    private enum State {
        case `default`
        case focused
        case disabled
    }
}
