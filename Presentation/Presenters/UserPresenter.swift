//
//  UserPresenter.swift
//  Presentation
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Domain

public protocol UserPresenterProtocol {
    func showUser(token: String) async throws -> UserViewModel
}

public final class UserPresenter: UserPresenterProtocol {
    private let interactor: UserInteractorProtocol
    
    public init(interactor: UserInteractorProtocol) {
        self.interactor = interactor
    }
    
    public func showUser(token: String) async throws -> UserViewModel {
        let response = try await interactor.getUser(token: token)
        return UserViewModel(response: response)
    }
}
