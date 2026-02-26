//
//  SignIn.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SignInFeature {
    @ObservableState
    struct State: Equatable {
        var id = ""
        var password = ""
        var error: ResponseError?
        var isLoading = false
        
        var isErrorPopUpShowing: Bool {
            get {
                error != nil
            }
            set {
                if newValue == false {
                    error = nil
                }
            }
        }
        
        var isSignInButtonDisabled: Bool {
            id.isEmpty || password.isEmpty
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case submitted
        case signInButtonTapped
        case signIn
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
                
            case .submitted:
                guard state.isSignInButtonDisabled == false else {
                    return .none
                }
                
                return .send(.signIn)
                
            case .signInButtonTapped:
                return .send(.signIn)
                
            case .signIn:
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

struct SignInView: View {
    @Bindable var store: StoreOf<SignInFeature>
    @State private var idFieldFocused = false
    @State private var passwordFieldFocused = false
    
    var body: some View {
        VStack(spacing: 0) {
            logo
            textFields
            signInButton
        }
        .background(AppColor.white.color)
        .onTapGesture {
            idFieldFocused = false
            passwordFieldFocused = false
        }
        .progressOverlay(visible: store.isLoading)
        .popUp(
            isShowing: $store.isErrorPopUpShowing,
            title: Texts.errorPopUpTitle(store.error),
            preferredButtonText: Texts.errorPopUpPreferredButton,
            onPreferredButtonTapped: {
                store.send(.errorPopUpDoneButtonTapped)
            }
        )
    }

    private var logo: some View {
        AppImage.logo.image
            .aspectRatio(contentMode: .fit)
            .padding(40)
            .frame(maxHeight: .infinity)
    }

    private var textFields: some View {
        VStack(spacing: 20) {
            idTextField
            passwordTextField
        }
        .padding(
            .horizontal,
            20
        )
    }

    private var idTextField: some View {
        AppTextField(
            text: $store.id,
            isFocused: $idFieldFocused,
            title: Texts.idTextFieldTitle,
            placeholder: Texts.idTextFieldPlaceholder,
            hidePlaceholderOnFocus: true
        )
        .textContentType(.oneTimeCode)
        .autocorrectionDisabled(true)
        .keyboardType(.asciiCapable)
    }

    private var passwordTextField: some View {
        AppTextField(
            text: $store.password,
            isFocused: $passwordFieldFocused,
            title: Texts.passwordTextFieldTitle,
            placeholder: Texts.passwordTextFieldPlaceholder,
            hidePlaceholderOnFocus: true,
            isSecureField: true
        )
        .textContentType(.oneTimeCode)
        .keyboardType(.asciiCapable)
        .onSubmit {
            store.send(.submitted)
        }
    }

    private var signInButton: some View {
        Button {
            store.send(.signInButtonTapped)
        } label: {
            Text(Texts.signInButton)
                .appFont(
                    .p2Bold,
                    color: .white
                )
                .padding(14)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(signInButtonColor)
                }
        }
        .disabled(store.isSignInButtonDisabled)
        .padding(20)
    }
}

// MARK: UI Properties
extension SignInView {
    private var signInButtonColor: Color {
        let appColor = store.isSignInButtonDisabled ? AppColor.gray30 : AppColor.black
        
        return appColor.color
    }
}

// MARK: Types
extension SignInView {
    private enum Texts {
        static func errorPopUpTitle(_ error: ResponseError?) -> String {
            switch error {
            case .loginFailed:
                "아이디 또는 비밀번호가 일치하지 않습니다."
            case .memberWithdrawn:
                "탈퇴한 사용자입니다."
            default:
                "일시적인 오류가 발생했습니다.잠시후 다시 시도해 주세요."
            }
        }
        
        static let errorPopUpPreferredButton = "확인"
        static let idTextFieldPlaceholder = "아이디를 입력해 주세요"
        static let idTextFieldTitle = "아이디"
        static let passwordTextFieldPlaceholder = "비밀번호를 입력해 주세요"
        static let passwordTextFieldTitle = "비밀번호"
        static let signInButton = "로그인"
    }
}

#if DEBUG
#Preview {
    SignInView(
        store: Store(
            initialState: SignInFeature.State()
        ) {
            SignInFeature()
        }
    )
}
#endif
