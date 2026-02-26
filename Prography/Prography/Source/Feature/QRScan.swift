//
//  QRScan.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct QRScanFeature {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {
        case closeButtonTapped
        case scanned(hashValue: String)
        case delegate(Delegate)
        
        enum Delegate {
            case scanned(hashValue: String)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .closeButtonTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case .scanned(let hashValue):
                return .send(.delegate(.scanned(hashValue: hashValue)))
                
            case .delegate:
                return .none
            }
        }
    }
}

struct QRScanView: View {
    @Bindable var store: StoreOf<QRScanFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            header
            ZStack {
                scanner
                dimCover
            }
        }
    }
    
    private var header: some View {
        HStack {
            Text(Texts.header)
                .appFont(
                    .h2Bold,
                    appColor: .black
                )
            Spacer()
            Button {
                store.send(.closeButtonTapped)
            } label: {
                AppIcon.close.image(
                    size: 24,
                    appColor: .black
                )
            }
        }
        .padding(
            .horizontal,
            20
        )
        .padding(
            .vertical,
            16
        )
        .background(AppColor.white.color)
    }
    
    private var scanner: some View {
        QRScanner { hashValue in
            store.send(.scanned(hashValue: hashValue))
        }
    }
    
    private var dimCover: some View {
        AppColor.black.color.opacity(0.6)
            .overlay(
                Rectangle()
                    .frame(
                        width: 200,
                        height: 200
                    )
                    .blendMode(.destinationOut)
            )
            .compositingGroup()
            .ignoresSafeArea()
    }
}

// MARK: Types
extension QRScanView {
    enum Texts {
        static let header = "출석 QR"
    }
}

#if DEBUG
#Preview {
    QRScanView(
        store: Store(
            initialState: QRScanFeature.State()
        ) {
            QRScanFeature()
        }
    )
}
#endif
