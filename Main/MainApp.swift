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
    @State private var tabSelected: MainApp.TabItem = .home
    @AppStorage("token") static var token: String = ""
    @AppStorage("coin") static var coin: String = ""
    @AppStorage("cash") static var cash: String = ""
    @State private var innerSelectTabAction: ((MainApp.TabItem) -> Void)?
    static var outSelectTabAction: ((MainApp.TabItem) -> Void)?
    
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
                .tag(MainApp.TabItem.user)
                
                NavigationStack {
                    initContentScene
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(MainApp.TabItem.home)
                
                NavigationStack {
                    analyticsScene
                }
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Status")
                }
                .tag(MainApp.TabItem.status)
            }
            .task {
                innerSelectTabAction = { item in
                    tabSelected = item
                }
                MainApp.outSelectTabAction = innerSelectTabAction
            }
        }
    }
    
    private var initContentScene: some View = makeInitContentScene()
    private var analyticsScene: some View = makeAnalyticsScene()
    private var loginScene: some View = makeLoginScene()
    private var userScene: some View = makeUserScene()
    
    static var tabMoney: some View {
        Button(action: { MainApp.outSelectTabAction?(.user) }, label: {
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
        })
    }
}

extension MainApp {
    enum TabItem: Int {
        case user = 1
        case home = 2
        case status = 3
    }
}
