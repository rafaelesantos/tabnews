//
//  RemoteAddLoginFactory.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Domain
import Data

func makeRemoteAddLogin() -> AddLogin {
    RemoteAddLogin(httpClient: makeNetworkAdapter(), httpEndpoint: LoginEndpoint())
}
