//
//  RemotePostRecoveryPasswordFactory.swift
//  Main
//
//  Created by Rafael Santos on 18/12/22.
//

import Foundation
import Data
import Domain

func makeRemotePostRecoveryPassword() -> PostRecoveryPassword {
    RemotePostRecoveryPassword(httpClient: makeNetworkAdapter(), httpEndpoint: RecoveryPasswordEndpoint())
}
