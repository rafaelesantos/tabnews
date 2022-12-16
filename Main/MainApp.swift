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
    @State private var tabSelected = 2
    @AppStorage("token") static var token: String = ""
    @AppStorage("coin") static var coin: String = ""
    @AppStorage("cash") static var cash: String = ""
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabSelected) {
                NavigationStack {
                    userScene
                }
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("User")
                }
                .tag(1)
                
                NavigationStack {
                    initContentScene
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(2)
                
                NavigationStack {
                    analyticsScene
                }
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Status")
                }
                .tag(3)
            }
        }
    }
    
    private var initContentScene: some View = makeInitContentScene()
    private var analyticsScene: some View = makeAnalyticsScene()
    private var loginScene: some View = makeLoginScene()
    private var userScene: some View = makeUserScene()
    
    static var tabMoney: some View {
        Menu {
            Button(action: {}, label: { CardBasicDetailView(title: "Tab Coin", description: MainApp.coin, image: "dollarsign.square.fill", imageColor: .blue) })
            Button(action: {}, label: { CardBasicDetailView(title: "Tab Cash", description: MainApp.cash, image: "dollarsign.square.fill", imageColor: .green) })
        } label: {
            HStack {
                if !MainApp.coin.isEmpty, !MainApp.cash.isEmpty {
                    Image(systemName: "dollarsign.square.fill")
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.blue)
                        .frame(width: 16, height: 16)
                    Text(MainApp.coin)
                        .foregroundColor(.primary)
                        .font(.footnote)
                    Image(systemName: "dollarsign.square.fill")
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.green)
                        .frame(width: 16, height: 16)
                    Text(MainApp.cash)
                        .foregroundColor(.primary)
                        .font(.footnote)
                }
            }
        }
    }
}
