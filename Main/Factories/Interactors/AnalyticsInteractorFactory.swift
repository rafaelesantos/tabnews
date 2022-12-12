//
//  AnalyticsInteractorFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Presentation

func makeAnalyticsInteractor() -> AnalyticsInteractor {
    AnalyticsInteractor(
        getAnalyticsUsersCreated: makeRemoteGetAnalyticsUsersCreated(withClient: makeNetworkAdapter()),
        getAnalyticsChildContentPublished: makeRemoteGetAnalyticsChildContentPublished(withClient: makeNetworkAdapter()),
        getAnalyticsRootContentPublished: makeRemoteGetAnalyticsRootContentPublished(withClient: makeNetworkAdapter()),
        getStatus: makeRemoteGetStatus(withClient: makeNetworkAdapter())
    )
}
