//
//  ContentChildSceneFactory.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import SwiftUI
import Presentation

func makeContentChildrenScene(viewModel: InitContentViewModel) throws -> some View {
    try ContentChildrenScene(previous: viewModel)
}
