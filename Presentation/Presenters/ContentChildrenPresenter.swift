//
//  ContentChildrenPresenter.swift
//  Presentation
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Domain

public protocol ContentChildrenPresenterProtocol {
    func showContentChildren() async throws -> [InitContentViewModel]
}

public final class ContentChildrenPresenter: ContentChildrenPresenterProtocol {
    private let interactor: ContentChildrenInteractorProtocol
    
    public init(interactor: ContentChildrenInteractorProtocol) {
        self.interactor = interactor
    }
    
    public func showContentChildren() async throws -> [InitContentViewModel] {
        let response = try await interactor.getContentChildren()
        return response.map({ InitContentViewModel(response: $0) })
    }
}
