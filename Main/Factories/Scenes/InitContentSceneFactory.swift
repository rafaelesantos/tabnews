//
//  InitContentSceneFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import SwiftUI

func makeInitContentScene(user: String? = nil) -> some View {
    InitContentScene(presenter: makeInitContentPresenter(endpoint: InitContentEndpoint(user: user)), user: user)
}
