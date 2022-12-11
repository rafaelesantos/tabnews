//
//  MainApp.swift
//  Main
//
//  Created by Rafael Santos on 10/12/22.
//

import SwiftUI
import UserInterface
import Data
import Presentation
import Infrastructure

@main
struct MainApp: App {
    
    public final class InitContentRouter: InitContentRouterProtocol {}
    
    func makePresenter() -> InitContentPresenterProtocol {
        let httpClient = TabNewsNetworkAdapter()
        let httpEnpoint = InitContentEndpoint()
        let useCase = RemoteGetInitContent(httpClient: httpClient, httpEndpoint: httpEnpoint)
        let interactor = InitContentInteractor(useCase: useCase)
        let router = InitContentRouter()
        return InitContentPresenter(interactor: interactor, router: router)
    }
    var body: some Scene {
        WindowGroup {
            TabView {
                InitContentView(presenter: makePresenter())
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
            }
        }
    }
}
