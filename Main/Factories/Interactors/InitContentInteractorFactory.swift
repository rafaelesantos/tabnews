//
//  InitContentInteractorFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Presentation
import Data

func makeInitContentInteractor(endpoint: TabNewsHttpEndpoint) -> InitContentInteractor {
    InitContentInteractor(useCase: makeRemoteGetInitContent(withClient: makeNetworkAdapter(), endpoint: endpoint))
}
