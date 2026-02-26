//
//  SignIn.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import ComposableArchitecture

@Reducer
struct SignInFeature {
    @ObservableState
    struct State: Equatable {
        var id = ""
        var idTextFieldFocused = false
        var password = ""
        var passwordTextFieldFocused = false
        var error: ResponseError?
        var isLoading = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case signInButtonTapped
        case startLoading
        case endLoading
        case setError(ResponseError)
        case errorPopUpDoneButtonTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case signInFinished(User)
        }
    }
    
    @Dependency(\.authService) var authService
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .signInButtonTapped:
                return .run { [id = state.id, password = state.password] send in
                    await send(.startLoading)
                    
                    let result = try await authService.signIn(
                        id: id,
                        password: password
                    )
                    
                    switch result {
                    case .success(let user):
                        await send(.delegate(.signInFinished(user)))
                    case .failure(let error):
                        await send(.setError(error))
                    }
                    
                    await send(.endLoading)
                } catch: { error, send in
                    #if DEBUG
                    print(error)
                    #endif
                    
                    await send(.endLoading)
                }
                
            case .startLoading:
                state.isLoading = true
                return .none

            case .endLoading:
                state.isLoading = false
                return .none
                
            case .setError(let error):
                state.error = error
                return .none
                
            case .errorPopUpDoneButtonTapped:
                state.error = nil
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
