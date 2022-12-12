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
    
    public init(interactor: ContentDataInteractorProtocol) {
        self.interactor = interactor
    }
    
    public func showContentData() async throws -> InitContentViewModel {
        let response = try await interactor.getContentData()
        return InitContentViewModel(response: response)
    }
}
