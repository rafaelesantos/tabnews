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
    
    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    public var body: some View {
        HStack {
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
