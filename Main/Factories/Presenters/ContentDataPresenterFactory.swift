//
//  ContentDataPresenterFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Presentation
import Data

func makeContentDataPresenter(endpoint: TabNewsHttpEndpoint) -> ContentDataPresenterProtocol {
    ContentDataPresenter(interactor: makeContentDataInteractor(endpoint: endpoint))
}
