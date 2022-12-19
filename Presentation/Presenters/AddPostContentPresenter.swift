//
//  AddPostContentPresenter.swift
//  Presentation
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation
import Domain

public protocol AddPostContentPresenterProtocol {
    func addPostContent(title: String, body: String, source: String?) async throws -> InitContentViewModel
}

public final class AddPostContentPresenter: AddPostContentPresenterProtocol {
    private let interactor: AddPostContentInteractorProtocol
    
    public init(interactor: AddPostContentInteractorProtocol) {
        self.interactor = interactor
    }
    
    public func addPostContent(title: String, body: String, source: String?) async throws -> InitContentViewModel {
        let response = try await interactor.addPostContent(title: title, body: body, source: source)
        return InitContentViewModel(response: response)
    }
}
