//
//  CardContentChildrenView.swift
//  UserInterface
//
//  Created by Rafael Santos on 12/12/22.
//

import SwiftUI
import Presentation
import RefdsUI
import MarkdownView

public struct CardContentChildrenView: View {
    private let viewModel: InitContentViewModel
    private let color: Color
    @State private var bodyContent: String = ""
    
    public init(viewModel: InitContentViewModel) {
        self.viewModel = viewModel
        color = .randomColor
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top, spacing: 5) {
                    Image(systemName: "ellipsis.message.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(color)
                        .padding(.trailing, 4)
                    if let username = viewModel.owner_username {
                        RefdsTag(username, color: color)
                    }
                    
                    if let tabCoins = viewModel.tabcoins, tabCoins > 0 {
                        RefdsTag("\(tabCoins) COINS", color: .yellow)
                    }
                    
                    Spacer(minLength: 6)
                    
                    if let date = viewModel.updated_at?.asString(withDateFormat: "dd MMMM - HH:mm"), !date.isEmpty {
                        RefdsText(date, size: .extraSmall, color: .secondary)
                            .padding([.top, .bottom], 4)
                    }
                }
                
                if let bodyContent = viewModel.body?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "\n", with: " ") {
                    RefdsText(bodyContent, lineLimit: 3)
                }
            }
        }
    }
}

struct CardContentChildrenView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NavigationLink(destination: Text("")) {
                CardContentChildrenView(viewModel: InitContentViewModel(title: "any-title", updated_at: Date(), tabcoins: 13, owner_username: "any-user", children_deep_count: 15, slug: "any-slug", body: "Sim, eu estou fazendo isso. Mas ?? exatamente o que eu queria evitar, pois o front ir?? ficar processando **n** objetos e separando toda vez que fizer a request, o que dependendo da quantidade, pode `penalizar o desempenho`.\n\nSe tivesse essa op????o para j?? vir filtrado somente as publica????es, seria uma \"delicinha\" ????\n\nMas como ainda n??o ?? poss??vel, d?? pra ir quebrando um galho dessa forma mesmo. Creio que n??o ir?? demorar pra ser implementado algo do tipo.\n\nDe qualquer forma, multo obrigado pelo feedback! ????????"))
            }
        }
    }
}
