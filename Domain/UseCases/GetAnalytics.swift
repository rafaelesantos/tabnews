//
//  GetAnalytics.swift
//  Domain
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation

public protocol GetAnalyticsChildContentPublished {
    typealias Result = Swift.Result<[AnalyticsChildContentPublishedResponse], TabNewsError>
    func getAnalyticsChildContentPublished() async -> Result
}

public protocol GetAnalyticsRootContentPublished {
    typealias Result = Swift.Result<[AnalyticsRootContentPublishedResponse], TabNewsError>
    func getAnalyticsRootContentPublished() async -> Result
}

public protocol GetAnalyticsUsersCreated {
    typealias Result = Swift.Result<[AnalyticsUsersCreatedResponse], TabNewsError>
    func getAnalyticsUsersCreated() async -> Result
}
