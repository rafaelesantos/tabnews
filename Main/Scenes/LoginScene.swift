//
//  LoginScene.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import SwiftUI
import Presentation
import UserInterface

struct LoginScene: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    
    @State private var color: Color = .blue
    @State private var presenter: LoginPresenterProtocol
    @State private var viewModel: LoginViewModel?
    @State private var needLoading: Bool = false
    @State private var isPresented: Bool = false
    @State private var stateScene: StateScene
    private var staticStateScene: StateScene
    
    @AppStorage("token") var token: String = ""
    
    init(state: LoginScene.StateScene = .login) {
        self._stateScene = State(initialValue: state)
        self._presenter = State(initialValue: makeLoginPresenter())
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
        .navigationDestination(isPresented: $isPresented, destination: { makeLoginScene(state: stateScene) })
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
            header
            description
            form
            button(title: "cadastrar") {
                if !email.isEmpty, !password.isEmpty, !username.isEmpty {
                    UIApplication.shared.endEditing()
                    //                    needLoading.toggle()
                    //                    Task {
                    //                        viewModel = try? await presenter.showLogin(email: email, password: password)
                    //                        if let viewModel = viewModel, !viewModel.response.token.isEmpty {
                    //                            token = viewModel.response.token
                    //                        }
                    //                        needLoading.toggle()
                    //                    }
                }
            }
        }
    }
    
    private var forgotPasswordScene: some View {
        VStack(spacing: 15) {
            header
            description
            form
            button(title: "recuperar") {
                if !email.isEmpty {
                    UIApplication.shared.endEditing()
                }
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 2) {
            Text("TAB")
                .font(.system(size: 30))
                .fontWeight(.black)
                .opacity(0.8)
            Text("NEWS")
                .font(.system(size: 30))
                .fontWeight(.black)
                .foregroundColor(color.opacity(0.8))
            Spacer()
        }
    }
    
    private var description: some View {
        HStack {
            Text("Conteúdos para quem trabalha com Programação e Tecnologia")
                .font(.footnote)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    private var form: some View {
        GroupBox {
            if staticStateScene == .signup {
                HStack(spacing: 15) {
                    Image(systemName: "person.text.rectangle.fill")
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.blue)
                        .frame(width: 28, height: 28)
                    Text("Username")
                        .lineLimit(1)
                    TextField("username", text: $username)
                        .textContentType(.username)
                        .keyboardType(.default)
                        .textCase(.lowercase)
                        .multilineTextAlignment(.trailing)
                }
                
                Divider()
            }
            
            HStack(spacing: 15) {
                Image(systemName: "person.crop.square.filled.and.at.rectangle.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.blue)
                    .frame(width: 28, height: 28)
                Text("E-mail")
                    .lineLimit(1)
                TextField("email@host.com", text: $email)
                    .textContentType(.emailAddress)
                    .textCase(.lowercase)
                    .keyboardType(.emailAddress)
                    .multilineTextAlignment(.trailing)
            }
            
            if staticStateScene == .login {
                Divider()
                
                HStack(spacing: 15) {
                    Image(systemName: "lock.rectangle.fill")
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.blue)
                        .frame(width: 28, height: 28)
                    Text("Senha")
                        .lineLimit(1)
                    SecureField("••••••••", text: $password)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    private var forgotPassword: some View {
        HStack(spacing: 6) {
            Text("Esqueceu a senha?")
                .font(.footnote)
                .foregroundColor(.secondary)
            Button {
                UIApplication.shared.endEditing()
                stateScene = .forgotPassword
                isPresented = true
            } label: {
                Text("Recuperar")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(color)
            }
            Spacer()
        }
    }
    
    private func button(title: String, action: @escaping () -> Void) -> some View {
        HStack(spacing: 10) {
            Button(action: action, label: {
                Text(title.uppercased())
                    .fontWeight(.black)
                    .foregroundColor(color)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
            })
            .background(color.opacity(0.2))
            .cornerRadius(10)
        }
    }
    
    private var progressView: some View {
        ProgressTabNewsView()
    }
    
    private var dontHaveAccount: some View {
        HStack(spacing: 6) {
            Text("Não possui conta?")
                .font(.footnote)
                .foregroundColor(.secondary)
            Button {
                UIApplication.shared.endEditing()
                stateScene = .signup
                isPresented = true
            } label: {
                Text("Cadastrar")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(color)
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
