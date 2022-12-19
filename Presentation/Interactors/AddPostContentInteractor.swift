//
//  AddPostContentInteractor.swift
//  Presentation
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation
import Domain
import Data

public protocol AddPostContentInteractorProtocol {
    func addPostContent(title: String, body: String, source: String?) async throws -> InitContentResponse
}

public final class AddPostContentInteractor: AddPostContentInteractorProtocol {
    private let useCase: AddPostContent
    
    public init(useCase: AddPostContent) {
        self.useCase = useCase
    }
    
    public func addPostContent(title: String, body: String, source: String?) async throws -> InitContentResponse {
        let result = await useCase.addPostContent(withBody: NewPostRequest(title: title, body: body, source_url: source))
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}
