//
//  AnalyticsSceneFactory.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import SwiftUI

func makeAnalyticsScene() -> some View {
    AnalyticsScene(presenter: makeAnalyticsPresenter())
}
