//
//  ContentDataInteractor.swift
//  Presentation
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Domain
import Data

public protocol ContentDataInteractorProtocol {
    func getContentData() async throws -> InitContentResponse
}

public final class ContentDataInteractor: ContentDataInteractorProtocol {
    private let useCase: GetContentData
    
    public init(useCase: GetContentData) {
        self.useCase = useCase
    }
    
    public func getContentData() async throws -> InitContentResponse {
        let result = await useCase.getContentData()
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}
