//
//  UserSceneFactory.swift
//  Main
//
//  Created by Rafael Santos on 13/12/22.
//

import Foundation
import SwiftUI

func makeUserScene(user: String? = nil) -> some View {
    UserScene(presenter: makeUserPresenter(user: user))
}
