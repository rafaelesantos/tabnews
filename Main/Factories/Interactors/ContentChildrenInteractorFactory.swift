//
//  ContentChildrenInteractorFactory.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Presentation
import Data

func makeContentChildrenInteractor(endpoint: TabNewsHttpEndpoint) -> ContentChildrenInteractorProtocol {
    ContentChildrenInteractor(useCase: makeRemoteContentChildren(endpoint: endpoint))
}
