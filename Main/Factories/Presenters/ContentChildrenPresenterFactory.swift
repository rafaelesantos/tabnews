//
//  ContentChildrenPresenterFactory.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Presentation
import Data

func makeContentChildrenPresenter(endpoint: TabNewsHttpEndpoint) -> ContentChildrenPresenterProtocol {
    ContentChildrenPresenter(interactor: makeContentChildrenInteractor(endpoint: endpoint))
}
