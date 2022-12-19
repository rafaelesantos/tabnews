//
//  DeletePostContentPresenter.swift
//  Presentation
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation
import Domain

public protocol DeletePostContentPresenterProtocol {
    func deletePostContent() async throws -> InitContentResponse
}

public final class DeletePostContentPresenter: DeletePostContentPresenterProtocol {
    private let interactor: DeletePostContentInteractorProtocol
    
    public init(interactor: DeletePostContentInteractorProtocol) {
        self.interactor = interactor
    }
    
    public func deletePostContent() async throws -> InitContentResponse {
        try await interactor.deletePostContent()
    }
}
