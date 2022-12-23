//
//  AddSignupPresenterFactory.swift
//  Main
//
//  Created by Rafael Santos on 22/12/22.
//

import Foundation
import Presentation

func makeAddSignupPresenter() -> AddSignupPresenterProtocol {
    AddSignupPresenter(interactor: makeSignupInteractor())
}
