//
//  RemoteAddSignupFactory.swift
//  Main
//
//  Created by Rafael Santos on 22/12/22.
//

import Foundation
import Data
import Domain

func makeRemoteAddSignup() -> AddSignup {
    RemoteAddSignup(httpClient: makeNetworkAdapter(), httpEndpoint: UserEndpoint(method: .post))
}
