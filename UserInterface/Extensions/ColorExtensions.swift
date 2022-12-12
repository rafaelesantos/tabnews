//
//  ColorExtensions.swift
//  UserInterface
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import SwiftUI

extension Color {
    public static var randomColor: Color {
        let colors: [Color] = [
            .orange,
            .blue,
            .green,
            .cyan,
            .red,
            .indigo,
            .pink,
            .mint,
            .purple,
            .teal
        ]
        let count = colors.count
        return colors[.random(in: 0...(count - 1))]
    }
}
