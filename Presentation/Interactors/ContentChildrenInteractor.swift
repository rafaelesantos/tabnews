//
//  ContentChildrenInteractor.swift
//  Presentation
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Domain
import Data

public protocol ContentChildrenInteractorProtocol {
    func getContentChildren() async throws -> [InitContentResponse]
}

public final class ContentChildrenInteractor: ContentChildrenInteractorProtocol {
    private let useCase: GetContentChildren
    
    public init(useCase: GetContentChildren) {
        self.useCase = useCase
    }
    
    public func getContentChildren() async throws -> [InitContentResponse] {
        let result = await useCase.getContentChildren()
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}
