//
//  RemoteGetContentChildrenFactory.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Data
import Domain

func makeRemoteContentChildren(endpoint: TabNewsHttpEndpoint) -> GetContentChildren {
    RemoteGetContentChildren(httpClient: makeNetworkAdapter(), httpEndpoint: endpoint)
}
