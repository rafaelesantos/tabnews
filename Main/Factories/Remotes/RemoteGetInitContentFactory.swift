//
//  RemoteGetInitContentFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Data

func makeRemoteGetInitContent(withClient client: TabNewsHttpClient, endpoint: TabNewsHttpEndpoint) -> RemoteGetInitContent {
    RemoteGetInitContent(httpClient: client, httpEndpoint: endpoint)
}
