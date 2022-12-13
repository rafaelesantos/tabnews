//
//  ContentDataSceneFactory.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import SwiftUI

func makeContentDataScene(user: String, slug: String) -> some View {
    ContentDataScene(presenter: makeContentDataPresenter(endpoint: ContentDataEndpoint(user: user, slug: slug)))
}
