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
    @State private var tabSelected = 1
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabSelected) {
                loginScene
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("User")
                    }
                
                NavigationView {
                    initContentScene
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                
                analyticsScene
                    .tabItem {
                        Image(systemName: "chart.bar.xaxis")
                        Text("Status")
                    }
            }
        }
    }
    
    private var initContentScene: some View = makeInitContentScene()
    private var analyticsScene: some View = makeAnalyticsScene()
    private var loginScene: some View = makeLoginScene()
}
