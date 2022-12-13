//
//  UserPresenterFactory.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Presentation
import Data

func makeUserPresenter(user: String? = nil) -> UserPresenterProtocol {
    UserPresenter(interactor: makeUserInteractor(user: user))
}
