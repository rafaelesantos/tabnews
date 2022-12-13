//
//  LoginScene.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import SwiftUI
import Presentation

struct LoginScene: View {
    @AppStorage("token") private var token: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var color: Color = .blue
    @State private var presenter: LoginPresenterProtocol
    @State private var viewModel: LoginViewModel?
    @State private var needLoading: Bool = false
    
    init() {
        self._presenter = State(initialValue: makeLoginPresenter())
    }
    
    var body: some View {
        VStack {
            GroupBox {
                VStack(spacing: 20) {
                    HStack(alignment: .center) {
                        HStack {
                            Text("TAB")
                                .font(.system(size: 30))
                                .fontWeight(.black)
                                .opacity(0.8)
                            Text("NEWS")
                                .font(.system(size: 30))
                                .fontWeight(.black)
                                .foregroundColor(color.opacity(0.8))
                        }
                        Spacer()
//                        Image(systemName: "xmark.circle.fill")
//                            .resizable()
//                            .foregroundColor(.blue)
//                            .scaledToFit()
//                            .frame(height: 30)
                    }
                    VStack(spacing: 12) {
                        HStack {
                            Text("Content for those who work with Programming and Technology.")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        HStack {
                            Text("Login")
                                .font(.title3)
                                .fontWeight(.black)
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
                                    .foregroundColor(color)
                            }
                            Spacer()
                        }
                    }
                    
                    HStack(spacing: 20) {
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
                            if needLoading { ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                            } else {
                                Text("LOGIN")
                                    .fontWeight(.black)
                                    .foregroundColor(color)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                            }
                        }
                        .background(color.opacity(0.2))
                        .cornerRadius(10)
                        
                        Button {
                            UIApplication.shared.endEditing()
                        } label: {
                            Image(systemName: "faceid")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(color)
                                .frame(height: 21)
                                .padding(12)
                                .background(color.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    
                    HStack(spacing: 6) {
                        Text("Don't have an account?")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Button {
                            UIApplication.shared.endEditing()
                        } label: {
                            Text("Signup here")
                                .font(.footnote)
                                .foregroundColor(color)
                        }
                        Spacer()
                    }
                }
            }
            .padding()
        }
        .padding()
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct LoginScene_Previews: PreviewProvider {
    static var previews: some View {
        LoginScene()
    }
}
