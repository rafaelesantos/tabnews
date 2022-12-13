//
//  LoginScene.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import SwiftUI
import Presentation

struct LoginScene: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var color: Color = .randomColor
    @State private var presenter: LoginPresenterProtocol
    @State private var viewModel: LoginViewModel?
    @State private var needLoading: Bool = false
    
    init() {
        self._presenter = State(initialValue: makeLoginPresenter())
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 10)
            HStack {
                GroupBox {
                    HStack {
                        Text("TAB")
                            .font(.system(size: 30))
                            .fontWeight(.black)
                            .opacity(0.8)
                        Text("NEWS")
                            .font(.system(size: 30))
                            .fontWeight(.black)
                            .foregroundColor(color.opacity(0.8))
                    }.padding(.bottom)
                }
                Spacer()
            }
            
            GroupBox {
                VStack(spacing: 12) {
                    Text("Content for those who work with Programming and Technology.")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(.secondary)
                    HStack {
                        Text("Login")
                            .font(.title3)
                            .fontWeight(.black)
                        Spacer()
                    }
                    
                    GroupBox {
                        HStack {
                            Text("E-mail")
                            Spacer()
                            TextField("example@host.com", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .multilineTextAlignment(.trailing)
                        }
                        Divider()
                        HStack {
                            Text("Password")
                            Spacer()
                            SecureField("••••••••••••••••••••", text: $password)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    HStack(spacing: 6) {
                        Text("Forgot password?")
                            .bold()
                            .foregroundColor(.secondary)
                        Button {
                            UIApplication.shared.endEditing()
                        } label: {
                            Text("Recover here")
                                .bold()
                                .foregroundColor(color)
                        }
                        Spacer()
                    }
                }
            }
            .padding(.top, -40)
            
            HStack(spacing: 20) {
                Button {
                    if !email.isEmpty, !password.isEmpty {
                        UIApplication.shared.endEditing()
                        needLoading.toggle()
                        Task {
                            viewModel = try? await presenter.showLogin(email: email, password: password)
                            if let viewModel = viewModel, !viewModel.response.token.isEmpty {
                                
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
                            .frame(height: 50)
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
                        .frame(height: 25)
                        .padding(12)
                        .background(color.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            
            if viewModel != nil {
                Text(viewModel?.response.token ?? "test")
                    .font(.footnote)
                    .bold()
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                Text("Don't have an account?")
                    .bold()
                    .foregroundColor(.secondary)
                Button {
                    UIApplication.shared.endEditing()
                } label: {
                    Text("Signup here")
                        .bold()
                        .foregroundColor(color)
                }

                Spacer(minLength: 10)
            }
        }
        .padding()
        .padding(.bottom, 20)
        .onAppear { color = .blue }
    }
}

struct LoginScene_Previews: PreviewProvider {
    static var previews: some View {
        LoginScene()
    }
}
