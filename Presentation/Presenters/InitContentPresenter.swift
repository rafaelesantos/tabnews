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
    
    public init(interactor: InitContentInteractorProtocol) {
        self.interactor = interactor
    }
    
    public func showInitContents() async throws -> [InitContentViewModel] {
        let response = try await interactor.getInitContent()
        return response.map({ InitContentViewModel(response: $0) })
    }
}
