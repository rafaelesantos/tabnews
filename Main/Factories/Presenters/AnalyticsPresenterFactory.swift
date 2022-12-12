//
//  AnalyticsPresenterFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Presentation

func makeAnalyticsPresenter() -> AnalyticsPresenterProtocol {
    AnalyticsPresenter(interactor: makeAnalyticsInteractor())
}
