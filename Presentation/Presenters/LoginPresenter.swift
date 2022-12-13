//
//  LoginPresenter.swift
//  Presentation
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Domain

public protocol LoginPresenterProtocol {
    func showLogin(email: String, password: String) async throws -> LoginViewModel
}

public final class LoginPresenter: LoginPresenterProtocol {
    private let interactor: LoginInteractorProtocol
    
    public init(interactor: LoginInteractorProtocol) {
        self.interactor = interactor
    }
    
    public func showLogin(email: String, password: String) async throws -> LoginViewModel {
        let response = try await interactor.addLogin(email: email, password: password)
        return LoginViewModel(response: response)
    }
}
