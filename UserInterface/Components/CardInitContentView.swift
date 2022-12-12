//
//  CardInitContentView.swift
//  UserInterface
//
//  Created by Rafael Santos on 10/12/22.
//

import SwiftUI
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
                        Text("\(tabCoins) COINS")
                            .bold()
                            .font(.system(size: 8))
                            .foregroundColor(.yellow)
                            .padding(6)
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(6)
                    }
                    
                    if let username = viewModel.owner_username {
                        TagTabNewsView(username, color: color)
                    }
                    
                    Spacer(minLength: 6)
                    
                    if let childrenDeepCount = viewModel.children_deep_count, childrenDeepCount > 0 {
                        HStack(alignment: .center) {
                            Image(systemName: "ellipsis.message.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(color)
                                .frame(maxHeight: 12)
                            Text("\(childrenDeepCount)")
                                .font(.system(size: 12))
                        }
                        .padding([.leading, .top, .bottom], 4)
                    }
                    
                    if let date = viewModel.updated_at?.asString(withDateFormat: "dd/MM - HH:mm"), !date.isEmpty {
                        Text(date)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .padding(4)
                    }
                }
                HStack {
                    if let title = viewModel.title {
                        Text(title)
                            .bold()
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
