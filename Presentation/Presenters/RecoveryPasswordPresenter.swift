//
//  RecoveryPasswordPresenter.swift
//  Presentation
//
//  Created by Rafael Santos on 18/12/22.
//

import Foundation
import Domain

public protocol RecoveryPasswordPresenterProtocol {
    func showRecoveryPassword(content: String) async throws -> RecoveryPasswordViewModel
}

public final class RecoveryPasswordPresenter: RecoveryPasswordPresenterProtocol {
    private let interactor: RecoveryPasswordInteractorProtocol
    
    public init(interactor: RecoveryPasswordInteractorProtocol) {
        self.interactor = interactor
    }
    
    public func showRecoveryPassword(content: String) async throws -> RecoveryPasswordViewModel {
        let response = try await interactor.postRecoveryPassword(content: content)
        return RecoveryPasswordViewModel(response: response)
    }
}
