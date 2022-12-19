//
//  RecoveryPasswordInteractor.swift
//  Presentation
//
//  Created by Rafael Santos on 18/12/22.
//

import Foundation
import Domain
import Data

public protocol RecoveryPasswordInteractorProtocol {
    func postRecoveryPassword(content: String) async throws -> RecoveryPasswordResponse
}

public final class RecoveryPasswordInteractor: RecoveryPasswordInteractorProtocol {
    private let useCase: PostRecoveryPassword
    
    public init(useCase: PostRecoveryPassword) {
        self.useCase = useCase
    }
    
    public func postRecoveryPassword(content: String) async throws -> RecoveryPasswordResponse {
        let result = await useCase.postRecoveryPassword(withBody: RecoveryPasswordRequest(username: content.isValidEmail ? nil : content, email: content.isValidEmail ? content : nil))
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}

extension String {
    var isValidEmail: Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
