//
//  AnswerInteractor.swift
//  Presentation
//
//  Created by Rafael Santos on 22/12/22.
//

import Foundation
import Domain
import Data

public protocol AnswerInteractorProtocol {
    func addAnswer(body: String, parent_id: String) async throws -> InitContentResponse
}

public final class AnswerInteractor: AnswerInteractorProtocol {
    private let useCase: AddAnswer
    
    public init(useCase: AddAnswer) {
        self.useCase = useCase
    }
    
    public func addAnswer(body: String, parent_id: String) async throws -> InitContentResponse {
        let result = await useCase.addAnswer(withBody: AnswerRequest(body: body, parent_id: parent_id))
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}
