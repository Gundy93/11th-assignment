//
//  Root.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import ComposableArchitecture

@Reducer
struct RootFeature {
    @ObservableState
    struct State: Equatable {
        var signIn = SignInFeature.State()
        var main: MainFeature.State?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case signIn(SignInFeature.Action)
        case main(MainFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(
            state: \.signIn,
            action: \.signIn
        ) {
            SignInFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .signIn(.delegate(.signInFinished(let user))):
                state.main = .init(user: user)
                return .none
                
            case .signIn:
                return .none
                
            case .main:
                return .none
            }
        }
        .ifLet(
            \.main,
             action: \.main
        ) {
            MainFeature()
        }
    }
}
