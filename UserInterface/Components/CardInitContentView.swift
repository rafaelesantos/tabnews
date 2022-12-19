//
//  CardInitContentView.swift
//  UserInterface
//
//  Created by Rafael Santos on 10/12/22.
//

import SwiftUI
import RefdsUI
import Presentation

public struct CardInitContentView: View {
    private let viewModel: InitContentViewModel
    private let color: Color
    
    public init(viewModel: InitContentViewModel) {
        self.viewModel = viewModel
        color = .randomColor
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top, spacing: 5) {
                    if let tabCoins = viewModel.tabcoins, tabCoins > 0 {
                        RefdsTag("\(tabCoins) COINS", color: .yellow)
                    }
                    
                    if let username = viewModel.owner_username {
                        RefdsTag(username, color: color)
                    }
                    
                    Spacer(minLength: 6)
                    
                    if let childrenDeepCount = viewModel.children_deep_count, childrenDeepCount > 0 {
                        HStack(alignment: .center) {
                            Image(systemName: "ellipsis.message.fill")
                                .symbolRenderingMode(.hierarchical)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(color)
                                .frame(maxHeight: 12)
                            RefdsText("\(childrenDeepCount)", size: .extraSmall)
                        }
                        .padding([.leading, .top, .bottom], 4)
                    }
                    
                    if let date = viewModel.updated_at?.asString(withDateFormat: "dd/MM - HH:mm"), !date.isEmpty {
                        RefdsText(date, size: .extraSmall, color: .secondary)
                            .padding([.leading, .top, .bottom], 4)
                    }
                }
                HStack {
                    if let title = viewModel.title {
                        RefdsText(title, size: .normal)
                    }
                }
            }
        }
    }
}

struct CardInitContentView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NavigationLink(destination: Text("")) {
                CardInitContentView(viewModel: InitContentViewModel(title: "any-title", updated_at: Date(), tabcoins: 13, owner_username: "any-user", children_deep_count: 15, slug: "any-slug"))
            }
        }
    }
}
