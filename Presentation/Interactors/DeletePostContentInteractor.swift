//
//  DeletePostContentInteractor.swift
//  Presentation
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation
import Domain

public protocol DeletePostContentInteractorProtocol {
    func deletePostContent() async throws -> InitContentResponse
}

public final class DeletePostContentInteractor: DeletePostContentInteractorProtocol {
    private let useCase: DeletePostContent
    
    public init(useCase: DeletePostContent) {
        self.useCase = useCase
    }
    
    public func deletePostContent() async throws -> InitContentResponse {
        let result = await useCase.deletePostContent(withBody: DeletePostRequest())
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}
