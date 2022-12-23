//
//  AddSignupPresenter.swift
//  Presentation
//
//  Created by Rafael Santos on 22/12/22.
//

import Foundation
import Domain

public protocol AddSignupPresenterProtocol {
    func addSignup(username: String, email: String, password: String) async throws -> UserViewModel
}

public final class AddSignupPresenter: AddSignupPresenterProtocol {
    private let interactor: SignupInteractorProtocol
    
    public init(interactor: SignupInteractorProtocol) {
        self.interactor = interactor
    }
    
    public func addSignup(username: String, email: String, password: String) async throws -> UserViewModel {
        let response = try await interactor.addSignup(username: username, email: email, password: password)
        return UserViewModel(response: response)
    }
}
