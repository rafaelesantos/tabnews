//
//  RecoveryPasswordPresenterFactory.swift
//  Main
//
//  Created by Rafael Santos on 18/12/22.
//

import Foundation
import Presentation
import Data

func makeRecoveryPasswordPresenter() -> RecoveryPasswordPresenterProtocol {
    RecoveryPasswordPresenter(interactor: makeRecoveryPasswordInteractor())
}
