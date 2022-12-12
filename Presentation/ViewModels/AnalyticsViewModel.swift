//
//  AnalyticsViewModel.swift
//  Presentation
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Domain

public struct AnalyticsViewModel {
    public let usersCreated: [AnalyticsUsersCreatedResponse]
    public let childContentPublished: [AnalyticsChildContentPublishedResponse]
    public let rootContentPublished: [AnalyticsRootContentPublishedResponse]
    public var status: StatusResponse
}
