//
//  TagTabNewsView.swift
//  UserInterface
//
//  Created by Rafael Santos on 10/12/22.
//

import SwiftUI

struct TagTabNewsView: View {
    var value: String
    var color: Color
    var action: (() -> Void)?
    
    init(_ value: String, color: Color, action: (() -> Void)? = nil) {
        self.value = value.uppercased()
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action ?? {}) {
            Text(value)
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(color)
        }
        .padding(6)
        .background(color.opacity(0.2))
        .cornerRadius(6)
    }
}

struct TagTabNewsView_Previews: PreviewProvider {
    static var previews: some View {
        TagTabNewsView("any-value", color: .orange)
    }
}
