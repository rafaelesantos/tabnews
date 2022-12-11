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
        return initContentResponse.map({ content in
            var updatedAt = content.updated_at?.replacingOccurrences(of: "T", with: " ")
            for _ in 0...7 { _ = updatedAt?.removeLast() }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let updatedAtDate = dateFormatter.date(from: updatedAt ?? "")
            return InitContentViewModel(
                title: content.title,
                updated_at: updatedAtDate,
                tabcoins: content.tabcoins,
                owner_username: content.owner_username,
                children_deep_count: content.children_deep_count
            )
        })
    }
}
