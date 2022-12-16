//
//  NavigationStackExtensions.swift
//  TabNews
//
//  Created by Rafael Santos on 15/12/22.
//

import Foundation
import SwiftUI

extension View {
    func setTabMoney() -> some View {
        self.toolbar {
            if !MainApp.cash.isEmpty, !MainApp.coin.isEmpty {
                ToolbarItem(placement: .navigationBarLeading) { MainApp.tabMoney }
            }
        }
    }
}
