//
//  CardBasicDetailView.swift
//  UserInterface
//
//  Created by Rafael Santos on 11/12/22.
//

import SwiftUI
import RefdsUI

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
        HStack(spacing: 15) {
            if let image = image, !image.isEmpty {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(imageColor == nil ? .primary : imageColor!)
            }
            RefdsText(title, size: .normal, lineLimit: 1)
            Spacer()
            RefdsText(description, size: .normal, color: .secondary, lineLimit: 1)
        }
    }
}

struct CardBasicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupBox {
            CardBasicDetailView(title: "any-title", description: "any-description", image: "bell.square.fill", imageColor: .red)
        }.padding()
    }
}
