//
//  Attendance.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AttendanceFeature {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {
        case signOutButtonTapped
        case delegate(Delegate)
        
        enum Delegate {
            case signOut
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .signOutButtonTapped:
                return .send(.delegate(.signOut))
                
            case .delegate:
                return .none
            }
        }
    }
}

struct AttendanceView: View {
    @Bindable var store: StoreOf<AttendanceFeature>
    
    var body: some View {
        signOutButton
    }
    
    private var signOutButton: some View {
        Button {
            store.send(.signOutButtonTapped)
        } label: {
            Text(Texts.signOutButton)
                .appFont(
                    .p2SemiBold,
                    appColor: .gray80
                )
        }
    }
}

// MARK: Types
extension AttendanceView {
    enum Texts {
        static let signOutButton = "로그아웃"
    }
}

#if DEBUG
#Preview {
    AttendanceView(
        store: Store(
            initialState: AttendanceFeature.State()
        ) {
            AttendanceFeature()
        }
    )
}
#endif
