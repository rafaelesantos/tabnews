//
//  RemoteGetStatusFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Domain
import Data

func makeRemoteGetStatus(withClient client: TabNewsHttpClient) -> GetStatus {
    RemoteGetStatus(httpClient: client, httpEndpoint: StatusEndpoint())
}
