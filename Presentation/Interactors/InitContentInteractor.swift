//
//  InitContentInteractor.swift
//  Presentation
//
//  Created by Rafael Santos on 09/12/22.
//

import Foundation
import Domain
import Data

public protocol InitContentInteractorProtocol {
    func getInitContent() async throws -> [InitContentResponse]
}

public final class InitContentInteractor: InitContentInteractorProtocol {
    private let useCase: GetInitContent
    
    public init(useCase: GetInitContent) {
        self.useCase = useCase
    }
    
    public func getInitContent() async throws -> [InitContentResponse] {
        let result = await useCase.getInitContent()
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}
