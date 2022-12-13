//
//  LoginInteractor.swift
//  Presentation
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Domain
import Data

public protocol LoginInteractorProtocol {
    func addLogin(email: String, password: String) async throws -> LoginResponse
}

public final class LoginInteractor: LoginInteractorProtocol {
    private let useCase: AddLogin
    
    public init(useCase: AddLogin) {
        self.useCase = useCase
    }
    
    public func addLogin(email: String, password: String) async throws -> LoginResponse {
        let result = await useCase.addLogin(withBody: LoginRequest(email: email, password: password))
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}
