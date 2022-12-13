//
//  UserInteractor.swift
//  Presentation
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Domain
import Data

public protocol UserInteractorProtocol {
    func getUser(token: String) async throws -> UserResponse
}

public final class UserInteractor: UserInteractorProtocol {
    private let useCase: GetUser
    
    public init(useCase: GetUser) {
        self.useCase = useCase
    }
    
    public func getUser(token: String) async throws -> UserResponse {
        let result = await useCase.getUser(token: token)
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}
