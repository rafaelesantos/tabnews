//
//  MainApp.swift
//  Main
//
//  Created by Rafael Santos on 10/12/22.
//

import SwiftUI
import RefdsUI
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
    
    init() {
        RefdsUI.shared.setNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabSelected) {
                NavigationStack {
                    userScene
                }
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    RefdsText("Usuário", size: .normal)
                }
                .tag(MainApp.TabItem.user)
                
                NavigationStack {
                    initContentScene
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    RefdsText("Início", size: .normal)
                }
                .tag(MainApp.TabItem.home)
                
                NavigationStack {
                    analyticsScene
                }
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    RefdsText("Status", size: .normal)
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
                    RefdsText(MainApp.coin, size: .small)
                    Image(systemName: "dollarsign.square.fill")
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.green)
                        .frame(width: 16, height: 16)
                    RefdsText(MainApp.cash, size: .small)
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

extension UIFont {
    class func preferredFont(from font: Font) -> UIFont {
        let style: UIFont.TextStyle
        switch font {
        case .largeTitle:  style = .largeTitle
        case .title:       style = .title1
        case .title2:      style = .title2
        case .title3:      style = .title3
        case .headline:    style = .headline
        case .subheadline: style = .subheadline
        case .callout:     style = .callout
        case .caption:     style = .caption1
        case .caption2:    style = .caption2
        case .footnote:    style = .footnote
        case .body: fallthrough
        default:           style = .body
        }
        return  UIFont.preferredFont(forTextStyle: style)
    }
}
