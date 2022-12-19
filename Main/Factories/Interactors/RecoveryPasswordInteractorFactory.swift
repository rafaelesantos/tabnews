//
//  RecoveryPasswordInteractorFactory.swift
//  Main
//
//  Created by Rafael Santos on 18/12/22.
//

import Foundation
import Presentation
import Data

func makeRecoveryPasswordInteractor() -> RecoveryPasswordInteractorProtocol {
    RecoveryPasswordInteractor(useCase: makeRemotePostRecoveryPassword())
}
