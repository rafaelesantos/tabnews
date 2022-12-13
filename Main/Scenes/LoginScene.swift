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
    @AppStorage("token") private var token: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var color: Color = .blue
    @State private var presenter: LoginPresenterProtocol
    @State private var viewModel: LoginViewModel?
    @State private var needLoading: Bool = false
    @State private var needFaceID: Bool = false
    
    init() {
        self._presenter = State(initialValue: makeLoginPresenter())
    }
    
    var body: some View {
            VStack(spacing: 15) {
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
                
                HStack {
                    Text("Content for those who work with Programming and Technology.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                GroupBox {
                    HStack(spacing: 10) {
                        Text("E-mail")
                            .multilineTextAlignment(.leading)
                        TextField("email@email.com", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Divider()
                    
                    HStack(spacing: 10) {
                        Text("Password")
                        SecureField("••••••••", text: $password)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                HStack(spacing: 6) {
                    Text("Forgot password?")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Button {
                        UIApplication.shared.endEditing()
                    } label: {
                        Text("Recover here")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(color)
                    }
                    Spacer()
                }
                
                HStack(spacing: 10) {
                    Button {
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
                    } label: {
                        Text("LOGIN")
                            .fontWeight(.black)
                            .foregroundColor(color)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                    }
                    .background(color.opacity(0.2))
                    .cornerRadius(10)
                    
                    Button {
                        
                    } label: {
                        Text("SIGNUP")
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                    }
                    .background(Color.primary.opacity(0.11))
                    .cornerRadius(10)
                }
                if needLoading { ProgressTabNewsView() }
            }
        .padding(.horizontal)
        .padding(.horizontal)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct LoginScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginScene()
        }
    }
}
