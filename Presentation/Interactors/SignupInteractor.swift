//
//  SignupInteractor.swift
//  Presentation
//
//  Created by Rafael Santos on 22/12/22.
//

import Foundation
import Domain

public protocol SignupInteractorProtocol {
    func addSignup(username: String, email: String, password: String) async throws -> UserResponse
}

public final class SignupInteractor: SignupInteractorProtocol {
    private let useCase: AddSignup
    
    public init(useCase: AddSignup) {
        self.useCase = useCase
    }
    
    public func addSignup(username: String, email: String, password: String) async throws -> UserResponse {
        let result = await useCase.addSignup(withBody: SignupRequest(username: username, email: email, password: password))
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}
