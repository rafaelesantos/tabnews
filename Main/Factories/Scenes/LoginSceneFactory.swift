//
//  LoginSceneFactory.swift
//  Main
//
//  Created by Rafael Santos on 13/12/22.
//

import Foundation
import SwiftUI

func makeLoginScene(state: LoginScene.StateScene = .login) -> some View {
    LoginScene(state: state)
}
