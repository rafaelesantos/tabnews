//
//  InitContentPresenter.swift
//  Presentation
//
//  Created by Rafael Santos on 09/12/22.
//

import Foundation
import Domain

public protocol InitContentPresenterProtocol {
    func showInitContents() async throws -> [InitContentViewModel]
}

public final class InitContentPresenter: InitContentPresenterProtocol {
    private let interactor: InitContentInteractorProtocol
    private let router: InitContentRouterProtocol
    
    public init(interactor: InitContentInteractorProtocol, router: InitContentRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    public func showInitContents() async throws -> [InitContentViewModel] {
        let response = try await interactor.getInitContent()
        return makeInitContentViewModels(from: response)
    }
}

public extension InitContentPresenter {
    private func makeInitContentViewModels(from initContentResponse: [InitContentResponse]) -> [InitContentViewModel] {
        return initContentResponse.map({
            InitContentViewModel(
                title: $0.title,
                updated_at: $0.updated_at,
                tabcoins: $0.tabcoins,
                owner_username: $0.owner_username
            )
        })
    }
}
