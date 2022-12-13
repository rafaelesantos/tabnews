//
//  RemoteGetUserFactory.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Data
import Domain

func makeRemoteGetUser(user: String) -> GetUser {
    RemoteGetUser(httpClient: makeNetworkAdapter(), httpEndpoint: UserEndpoint(user: user))
}
