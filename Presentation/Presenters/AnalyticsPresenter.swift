//
//  AnalyticsPresenter.swift
//  Presentation
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Domain

public protocol AnalyticsPresenterProtocol {
    func showStatus() async throws -> AnalyticsViewModel?
    func showAnalytics() async throws -> AnalyticsViewModel?
}

public final class AnalyticsPresenter: AnalyticsPresenterProtocol {
    private let interactor: AnalyticsInteractorProtocol
    
    public init(interactor: AnalyticsInteractorProtocol) {
        self.interactor = interactor
    }
    
    public func showAnalytics() async throws -> AnalyticsViewModel? {
        return try await interactor.getAnalytics()
    }
    
    public func showStatus() async throws -> AnalyticsViewModel? {
        return try await interactor.getAnalyticsStatus()
    }
}
