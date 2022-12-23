//
//  AnswerPresenter.swift
//  Presentation
//
//  Created by Rafael Santos on 22/12/22.
//

import Foundation
import Domain

public protocol AnswerPresenterProtocol {
    func addAnswer(body: String, parent_id: String) async throws -> InitContentViewModel
}

public final class AnswerPresenter: AnswerPresenterProtocol {
    private let interactor: AnswerInteractorProtocol
    
    public init(interactor: AnswerInteractorProtocol) {
        self.interactor = interactor
    }
    
    public func addAnswer(body: String, parent_id: String) async throws -> InitContentViewModel {
        let response = try await interactor.addAnswer(body: body, parent_id: parent_id)
        return InitContentViewModel(response: response)
    }
}
