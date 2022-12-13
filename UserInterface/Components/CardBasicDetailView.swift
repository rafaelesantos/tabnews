//
//  CardBasicDetailView.swift
//  UserInterface
//
//  Created by Rafael Santos on 11/12/22.
//

import SwiftUI

public struct CardBasicDetailView: View {
    private let title: String
    private let description: String
    private let image: String?
    private let imageColor: Color?
    
    public init(title: String, description: String, image: String? = nil, imageColor: Color? = nil) {
        self.title = title
        self.description = description
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
            Text(description)
                .font(.footnote)
                .bold()
                .foregroundColor(.secondary)
        }
    }
}

struct CardBasicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupBox {
            CardBasicDetailView(title: "any-title", description: "any-description")
        }.padding()
    }
}
