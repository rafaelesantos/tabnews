//
//  CardBasicDetailTagView.swift
//  UserInterface
//
//  Created by Rafael Santos on 11/12/22.
//

import SwiftUI

public struct CardBasicDetailTagView: View {
    private let title: String
    private let description: String
    private let color: Color
    
    public init(title: String, description: String, color: Color = .randomColor) {
        self.title = title
        self.description = description
        self.color = color
    }
    
    public var body: some View {
        HStack {
            Text(title)
            Spacer()
            TagTabNewsView(description, color: color)
        }
    }
}

struct CardBasicDetailTagView_Previews: PreviewProvider {
    static var previews: some View {
        GroupBox {
            CardBasicDetailTagView(title: "any-title", description: "any-description")
        }.padding()
    }
}
