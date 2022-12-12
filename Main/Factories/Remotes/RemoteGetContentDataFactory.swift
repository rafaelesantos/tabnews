//
//  RemoteGetContentDataFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Domain
import Data

func makeRemoteContentData(endpoint: TabNewsHttpEndpoint) -> GetContentData {
    RemoteGetContentData(httpClient: makeNetworkAdapter(), httpEndpoint: endpoint)
}
