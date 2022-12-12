//
//  InitContentSceneFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import SwiftUI

func makeInitContentScene() -> some View {
    InitContentScene(presenter: makeInitContentPresenter())
}
