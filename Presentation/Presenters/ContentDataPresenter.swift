//
//  ContentDataPresenter.swift
//  Presentation
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Domain

public protocol ContentDataPresenterProtocol {
    func showContentData() async throws -> InitContentViewModel
}

public final class ContentDataPresenter: ContentDataPresenterProtocol {
    private let interactor: ContentDataInteractorProtocol
    private let router: ContentDataRouterProtocol
    
    public init(interactor: ContentDataInteractorProtocol, router: ContentDataRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    public func showContentData() async throws -> InitContentViewModel {
        let response = try await interactor.getContentData()
        return makeContentDataViewModel(from: response)
    }
}

public extension ContentDataPresenter {
    private func makeContentDataViewModel(from contentDataResponse: InitContentResponse) -> InitContentViewModel {
        var updatedAt = contentDataResponse.updated_at?.replacingOccurrences(of: "T", with: " ")
        for _ in 0...7 { _ = updatedAt?.removeLast() }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let updatedAtDate = dateFormatter.date(from: updatedAt ?? "")
        return InitContentViewModel(
            title: contentDataResponse.title,
            updated_at: updatedAtDate,
            tabcoins: contentDataResponse.tabcoins,
            owner_username: contentDataResponse.owner_username,
            children_deep_count: contentDataResponse.children_deep_count,
            slug: contentDataResponse.slug,
            body: contentDataResponse.body
        )
    }
}
