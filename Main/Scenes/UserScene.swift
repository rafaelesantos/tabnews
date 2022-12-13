//
//  UserScene.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import SwiftUI
import Presentation

struct UserScene: View {
    @State private var presenter: UserPresenterProtocol
    
    init(presenter: UserPresenterProtocol) {
        self._presenter = State(initialValue: presenter)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct UserScene_Previews: PreviewProvider {
    static var previews: some View {
        UserScene(presenter: makeUserPresenter(user: "GabrielSozinho"))
    }
}
