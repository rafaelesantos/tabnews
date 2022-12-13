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
    private let image: String?
    private let imageColor: Color?
    
    public init(title: String, description: String, color: Color = .randomColor, image: String? = nil, imageColor: Color? = nil) {
        self.title = title
        self.description = description
        self.color = color
        self.image = image
        self.imageColor = imageColor
    }
    
    public var body: some View {
        HStack {
            if let image = image, !image.isEmpty {
                Image(systemName: image)
                    .foregroundColor(imageColor == nil ? .primary : imageColor!)
            }
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
