//
//  ContentDataInteractorFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Presentation
import Data

func makeContentDataInteractor(endpoint: TabNewsHttpEndpoint) -> ContentDataInteractorProtocol {
    ContentDataInteractor(useCase: makeRemoteContentData(endpoint: endpoint))
}
