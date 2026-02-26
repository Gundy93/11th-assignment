//
//  PopUp.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import SwiftUI

struct PopUp: View {
    let title: String
    let description: String?
    let preferredButtonText: String?
    let onPreferredButtonTapped: (() -> Void)?
    let subButtonText: String?
    let onSubButtonTapped: (() -> Void)?
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            message
            buttons
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColor.white.color)
        }
        .padding(20)
    }

    private var message: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            titleText
            descriptionText
        }
        .padding(messageEdgeInsets)
    }
    
    var titleText: some View {
        Text(title)
            .appFont(
                .p1Bold,
                appColor: .black
            )
    }

    @ViewBuilder
    private var descriptionText: some View {
        if let description {
            Text(description)
                .appFont(
                    .p1Regular,
                    appColor: .black
                )
        }
    }

    private var buttons: some View {
        HStack(spacing: 40) {
            Spacer()
            subButton
            preferredButton
        }
        .padding(buttonsEdgeInsets)
    }

    @ViewBuilder
    private var subButton: some View {
        if let subButtonText {
            Button {
                onSubButtonTapped?()
            } label: {
                Text(subButtonText)
                    .appFont(
                        .p2SemiBold,
                        appColor: .gray50
                    )
            }
        }
    }

    @ViewBuilder
    private var preferredButton: some View {
        if let preferredButtonText {
            Button {
                onPreferredButtonTapped?()
            } label: {
                Text(preferredButtonText)
                    .appFont(
                        .p2SemiBold,
                        appColor: .primary
                    )
            }
        }
    }
}

// MARK: UI Properties
extension PopUp {
    private var messageEdgeInsets: EdgeInsets {
        EdgeInsets(
            top: 20,
            leading: 20,
            bottom: 16,
            trailing: 20
        )
    }

    private var buttonsEdgeInsets: EdgeInsets {
        EdgeInsets(
            top: 16,
            leading: 24,
            bottom: 16,
            trailing: 24
        )
    }
}

extension View {
    func popUp(
        isShowing: Binding<Bool>,
        title: String,
        description: String? = nil,
        preferredButtonText: String? = nil,
        onPreferredButtonTapped: (() -> Void)? = nil,
        subButtonText: String? = nil,
        onSubButtonTapped: (() -> Void)? = nil,
        canDismissWithOutsideTapping: Bool = false
    ) -> some View {
        ZStack {
            self
                .dim(visible: isShowing.wrappedValue)
                .onTapGesture {
                    if canDismissWithOutsideTapping {
                        isShowing.wrappedValue = false
                    }
                }

            VStack {
                if isShowing.wrappedValue {
                    PopUp(
                        title: title,
                        description: description,
                        preferredButtonText: preferredButtonText,
                        onPreferredButtonTapped: onPreferredButtonTapped,
                        subButtonText: subButtonText,
                        onSubButtonTapped: onSubButtonTapped
                    )
                    .transition(.popUp)
                }
            }
        }
        .animation(
            .easeIn(duration: 0.15),
            value: isShowing.wrappedValue
        )
    }
}

extension AnyTransition {
    static var popUp: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 1.2).combined(with: .opacity),
            removal: .opacity
        )
    }
}
