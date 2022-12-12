//
//  AnalyticsInteractor.swift
//  Presentation
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Domain
import Data

public protocol AnalyticsInteractorProtocol {
    func getAnalytics() async throws -> AnalyticsViewModel?
    func getAnalyticsStatus() async throws -> AnalyticsViewModel?
}

public final class AnalyticsInteractor: AnalyticsInteractorProtocol {
    private let getAnalyticsUsersCreated: GetAnalyticsUsersCreated
    private let getAnalyticsChildContentPublished: GetAnalyticsChildContentPublished
    private let getAnalyticsRootContentPublished: GetAnalyticsRootContentPublished
    private let getStatus: GetStatus
    private var responseViewModel: AnalyticsViewModel?
    
    public init(
        getAnalyticsUsersCreated: GetAnalyticsUsersCreated,
        getAnalyticsChildContentPublished: GetAnalyticsChildContentPublished,
        getAnalyticsRootContentPublished: GetAnalyticsRootContentPublished,
        getStatus: GetStatus
    ) {
        self.getAnalyticsUsersCreated = getAnalyticsUsersCreated
        self.getAnalyticsChildContentPublished = getAnalyticsChildContentPublished
        self.getAnalyticsRootContentPublished = getAnalyticsRootContentPublished
        self.getStatus = getStatus
    }
    
    public func getAnalytics() async throws -> AnalyticsViewModel? {
        let resultUsersCreated = await getAnalyticsUsersCreated.getAnalyticsUsersCreated()
        let resultChildContentPublished = await getAnalyticsChildContentPublished.getAnalyticsChildContentPublished()
        let resultRootContentPublished = await getAnalyticsRootContentPublished.getAnalyticsRootContentPublished()
        let resultSatus = await getStatus.getStatus()
        
        switch (resultUsersCreated, resultRootContentPublished, resultChildContentPublished, resultSatus) {
            
        case (.success(let usersCreatedResponse), .success(let rootContentPublishedResponse), .success(let childContentPublishedResponse), .success(let statusResponse)):
            responseViewModel = AnalyticsViewModel(
                usersCreated: usersCreatedResponse,
                childContentPublished: childContentPublishedResponse,
                rootContentPublished: rootContentPublishedResponse,
                status: statusResponse
            )
            return responseViewModel
        default: throw NSError(domain: "analytics.get", code: 1)
        }
    }
    
    public func getAnalyticsStatus() async throws -> AnalyticsViewModel? {
        let result = await getStatus.getStatus()
        switch result {
        case .success(let statusResponse):
            responseViewModel?.status = statusResponse
            return responseViewModel
        case .failure(let error):
            throw error
        }
    }
}
