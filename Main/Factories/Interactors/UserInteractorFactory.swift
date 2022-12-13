//
//  UserInteractorFactory.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Presentation
import Data

func makeUserInteractor(user: String? = nil) -> UserInteractorProtocol {
    UserInteractor(useCase: makeRemoteGetUser(user: user))
}
