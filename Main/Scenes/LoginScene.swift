//
//  LoginScene.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import SwiftUI
import RefdsUI
import Presentation
import UserInterface

struct LoginScene: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    
    @State private var color: Color = .blue
    @State private var presenter: LoginPresenterProtocol
    @State private var presenterRecoveryPassword: RecoveryPasswordPresenterProtocol
    @State private var presenterSignup: AddSignupPresenterProtocol?
    @State private var viewModel: LoginViewModel?
    @State private var viewModelRecoveryPassword: RecoveryPasswordViewModel?
    @State private var viewModelSignup: UserViewModel?
    @State private var needLoading: Bool = false
    @State private var isPresented: Bool = false
    @State private var stateScene: StateScene
    private var staticStateScene: StateScene
    
    private var isEnableButton: Bool {
        switch staticStateScene {
        case .forgotPassword: return !username.isEmpty || !email.isEmpty
        case .signup: return !username.isEmpty && !email.isEmpty && !password.isEmpty
        case .login: return !email.isEmpty && !password.isEmpty
        }
    }
    
    @AppStorage("token") var token: String = ""
    
    init(state: LoginScene.StateScene = .login) {
        self._stateScene = State(initialValue: state)
        self._presenter = State(initialValue: makeLoginPresenter())
        self._presenterRecoveryPassword = State(initialValue: makeRecoveryPasswordPresenter())
        self._presenterSignup = State(initialValue: makeAddSignupPresenter())
        staticStateScene = state
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 15) {
                    switch staticStateScene {
                    case .login: loginScene
                    case .signup: signupScene
                    case .forgotPassword: forgotPasswordScene
                    }
                }
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
        .padding(.horizontal)
        .padding(.horizontal)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .navigationDestination(isPresented: $isPresented, destination: {
            makeLoginScene(state: stateScene)
        })
    }
    
    private var loginScene: some View {
        VStack(spacing: 15) {
            header
            description
            form
            forgotPassword
            button(title: "acessar") {
                if !email.isEmpty, !password.isEmpty {
                    UIApplication.shared.endEditing()
                    needLoading.toggle()
                    Task {
                        viewModel = try? await presenter.showLogin(email: email, password: password)
                        if let viewModel = viewModel, !viewModel.response.token.isEmpty {
                            token = viewModel.response.token
                        }
                        needLoading.toggle()
                    }
                }
            }
            if needLoading { progressView }
            dontHaveAccount
        }
    }
    
    private var signupScene: some View {
        VStack(spacing: 15) {
            if let _ = viewModelSignup {
                VStack(spacing: 5) {
                    RefdsText("Confira seu e-mail: \(email)", size: .extraLarge, weight: .bold)
                    RefdsText("Você receberá um link para confirmar seu cadastro e ativar a sua conta.", size: .normal, color: .secondary, alignment: .center)
                }
            } else {
                header
                description
                form
                button(title: "cadastrar") {
                    if !email.isEmpty, !password.isEmpty, !username.isEmpty {
                        UIApplication.shared.endEditing()
                        needLoading.toggle()
                        Task {
                            viewModelSignup = try? await presenterSignup?.addSignup(username: username, email: email, password: password)
                            needLoading.toggle()
                        }
                    }
                }
                if needLoading { progressView }
            }
        }
    }
    
    private var forgotPasswordScene: some View {
        VStack(spacing: 15) {
            if let _ = viewModelRecoveryPassword {
                VStack(spacing: 5) {
                    RefdsText("Confira seu e-mail", size: .extraLarge, weight: .bold)
                    RefdsText("Você receberá um link para definir uma nova senha.", size: .normal, color: .secondary, alignment: .center)
                }
            } else {
                header
                description
                form
                button(title: "recuperar") {
                    if !email.isEmpty || !username.isEmpty {
                        UIApplication.shared.endEditing()
                        needLoading.toggle()
                        Task {
                            viewModelRecoveryPassword = try? await presenterRecoveryPassword.showRecoveryPassword(content: email.isEmpty ? username : email)
                            needLoading.toggle()
                        }
                    }
                }
                if needLoading { progressView }
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 2) {
            RefdsText("TAB", size: .custom(30), weight: .black)
            RefdsText("NEWS", size: .custom(30), color: color, weight: .black)
            Spacer()
        }
    }
    
    private var description: some View {
        HStack {
            RefdsText(
                "Conteúdos para quem trabalha com Programação e Tecnologia",
                size: .small,
                color: .secondary,
                family: .moderat
            )
            Spacer()
        }
    }
    
    private var form: some View {
        GroupBox {
            if staticStateScene == .signup || staticStateScene == .forgotPassword {
                HStack(spacing: 15) {
                    RefdsText("Username", size: .normal, lineLimit: 1)
                    TextField("username", text: $username)
                        .textContentType(.username)
                        .keyboardType(.default)
                        .textCase(.lowercase)
                        .multilineTextAlignment(.trailing)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(.refds(size: 16, scaledSize: 1.2 * 16))
                }
                
                Divider()
            }
            
            HStack(spacing: 15) {
                RefdsText("E-mail", size: .normal, lineLimit: 1)
                TextField("email@host.com", text: $email)
                    .textContentType(.emailAddress)
                    .textCase(.lowercase)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .multilineTextAlignment(.trailing)
                    .autocorrectionDisabled()
                    .font(.refds(size: 16, scaledSize: 1.2 * 16))
            }
            
            if staticStateScene == .login || staticStateScene == .signup {
                Divider()
                
                HStack(spacing: 15) {
                    RefdsText("Senha", size: .normal, lineLimit: 1)
                        .lineLimit(1)
                    SecureField("• • • • • • • •", text: $password)
                        .multilineTextAlignment(.trailing)
                        .textInputAutocapitalization(.never)
                        .font(.refds(size: 16, scaledSize: 1.2 * 16))
                }
            }
        }
    }

    private var forgotPassword: some View {
        HStack(spacing: 6) {
            RefdsText(
                "Esqueceu a senha?",
                size: .small,
                color: .secondary,
                family: .moderat
            )
            Button {
                UIApplication.shared.endEditing()
                stateScene = .forgotPassword
                isPresented = true
            } label: {
                RefdsText(
                    "Recuperar",
                    size: .small,
                    color: color,
                    weight: .bold,
                    family: .moderat
                )
            }
            Spacer()
        }
    }
    
    private func button(title: String, action: @escaping () -> Void) -> some View {
        HStack(spacing: 10) {
            let color: Color = isEnableButton ? color : .secondary
            Button(action: action, label: {
                RefdsText(title.uppercased(), size: .normal, color: color, weight: .bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
            })
            .background(isEnableButton ? color.opacity(0.2) : Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
        }
    }
    
    private var progressView: some View {
        ProgressTabNewsView()
    }
    
    private var dontHaveAccount: some View {
        HStack(spacing: 6) {
            RefdsText(
                "Não possui conta?",
                size: .small,
                color: .secondary,
                family: .moderat
            )
            Button {
                UIApplication.shared.endEditing()
                stateScene = .signup
                isPresented = true
            } label: {
                RefdsText(
                    "Cadastrar",
                    size: .small,
                    color: color,
                    weight: .bold,
                    family: .moderat
                )
            }
            Spacer()
        }
    }
}

extension LoginScene {
    enum StateScene {
        case login
        case signup
        case forgotPassword
    }
}

struct LoginScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginScene()
        }
    }
}
