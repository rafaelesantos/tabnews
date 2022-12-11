//
//  CardInitContentView.swift
//  UserInterface
//
//  Created by Rafael Santos on 10/12/22.
//

import SwiftUI

struct CardInitContentView: View {
    var title: String
    var user: String
    var date: String?
    var tabCoins: Int?
    
    var colors: [Color] = [
        .yellow,
        .orange,
        .blue,
        .green,
        .cyan,
        .red,
        .indigo,
        .pink
    ]
    
    init(title: String, user: String, date: String? = nil, tabCoins: Int? = nil) {
        self.title = title
        self.user = user
        self.date = date
        self.tabCoins = tabCoins
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top, spacing: 5) {
                    TagTabNewsView(user, color: colors[.random(in: 0...7)])
                    if let date = date, !date.isEmpty {
                        Spacer(minLength: 10)
                        Text(date)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                HStack {
                    Text(title)
                        .bold()
                    if let tabCoins = tabCoins {
                        Spacer()
                        Text("\(tabCoins)")
                            .bold()
                            .font(.system(size: 14))
                            .foregroundColor(.yellow)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
            }
        }
//        .padding(12)
//        .background(Color(uiColor: .systemBackground))
//        .cornerRadius(10)
    }
}

struct CardInitContentView_Previews: PreviewProvider {
    static var previews: some View {
        CardInitContentView(title: "Any-title", user: "any-user", date: "dd/MM/yyyy HH:mm", tabCoins: 5)
    }
}
