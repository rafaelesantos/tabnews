//
//  InitContentPresenterFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import SwiftUI
import Data
import Presentation

func makeInitContentPresenter(endpoint: TabNewsHttpEndpoint = InitContentEndpoint()) -> InitContentPresenter {
    InitContentPresenter(interactor: makeInitContentInteractor(endpoint: endpoint), router: makeInitContentRouter())
}
