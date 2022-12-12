//
//  RemoteGetAnalyticsFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Domain
import Data

func makeRemoteGetAnalyticsChildContentPublished(withClient client: TabNewsHttpClient) -> GetAnalyticsChildContentPublished {
    RemoteGetAnalyticsChildContentPublished(httpClient: client, httpEndpoint: AnalyticsChildContentPublishedEndpoint())
}

func makeRemoteGetAnalyticsRootContentPublished(withClient client: TabNewsHttpClient) -> GetAnalyticsRootContentPublished {
    RemoteGetAnalyticsRootContentPublished(httpClient: client, httpEndpoint: AnalyticsRootContentPublishedEndpoint())
}

func makeRemoteGetAnalyticsUsersCreated(withClient client: TabNewsHttpClient) -> GetAnalyticsUsersCreated {
    RemoteGetAnalyticsUsersCreated(httpClient: client, httpEndpoint: AnalyticsUsersCreatedEndpoint())
}
