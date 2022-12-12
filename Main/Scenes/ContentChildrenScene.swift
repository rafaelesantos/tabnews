//
//  ContentChildrenScene.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import SwiftUI
import Presentation
import UserInterface
import Markdown

struct ContentChildrenScene: View {
    @State private var presenter: ContentChildrenPresenterProtocol
    @State private var previousViewModel: InitContentViewModel
    @State private var viewModel: [InitContentViewModel] = []
    @State private var needLoading: Bool = false
    
    init(previous: InitContentViewModel) throws {
        guard let user = previous.owner_username, let slug = previous.slug else { throw NSError(domain: "content.child", code: 1) }
        self._presenter = State(initialValue: makeContentChildrenPresenter(endpoint: ContentChildrenEndpoint(user: user, slug: slug)))
        self._previousViewModel = State(initialValue: previous)
    }
    
    var body: some View {
        List {
            Section("previous subject") {
                if let body = previousViewModel.body?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) {
                    HStack(spacing: 15) {
                        VStack {
                            Image(systemName: "chevron.up")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(previousViewModel.tabcoins ?? 0)")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.yellow)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.secondary)
                        }.padding(.vertical, 10)
                        
                        Text(body.replacingOccurrences(of: "*", with: ""))
                            .lineLimit(3)
                            .bold()
                    }.disabled(true)
                }
                
                NavigationLink(destination: makeInitContentScene(user: previousViewModel.owner_username)) {
                    CardBasicDetailTagView(title: "Author", description: previousViewModel.owner_username ?? "")
                }
                
                if let date = previousViewModel.updated_at?.asString(withDateFormat: "dd MMMM - HH:mm") {
                    CardBasicDetailView(title: "Date", description: date)
                        .disabled(true)
                }
            }
            
            if !needLoading {
                ForEach(viewModel, id: \.id) { content in
                    Section {
                        CardContentChildrenView(viewModel: content)
                            .disabled(true)
                        if let commentsAmount = content.children_deep_count, commentsAmount > 0, let contentChildrenView = try? makeContentChildrenScene(viewModel: content) {
                            NavigationLink(destination: contentChildrenView) {
                                commentsInfo(commentsAmount: commentsAmount)
                            }
                        }
                    }
                }
            }
        }
        .refreshable { Task { await loadData() } }
        .task { await loadData() }
        .navigationTitle("Comments")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if needLoading { ProgressView() }
            }
        }
    }
    
    private func commentsInfo(commentsAmount: Int) -> some View {
        HStack {
            Image(systemName: "ellipsis.message.fill")
                .foregroundColor(.blue.opacity(0.8))
            Text("Comments")
            Spacer()
            Text("\(commentsAmount > 0 ? "\(commentsAmount)" : "No Comments")")
                .font(.footnote)
                .bold()
                .foregroundColor(.secondary)
        }
    }
    
    private func loadData() async {
        needLoading.toggle()
        viewModel = (try? await presenter.showContentChildren()) ?? []
        needLoading.toggle()
    }
}

struct ContentChildrenScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            try? ContentChildrenScene(previous: InitContentViewModel(title: "any-title", updated_at: Date(), tabcoins: 28, owner_username: "GabrielSozinho", children_deep_count: 19, slug: "documentacao-da-api-do-tabnews", body: "Sim, eu estou fazendo isso. Mas é exatamente o que eu queria evitar, pois o front irá ficar processando **n** objetos e separando toda vez que fizer a request, o que dependendo da quantidade, pode `penalizar o desempenho`.\n\nSe tivesse essa opção para já vir filtrado somente as publicações, seria uma \"delicinha\" 😅\n\nMas como ainda não é possível, dá pra ir quebrando um galho dessa forma mesmo. Creio que não irá demorar pra ser implementado algo do tipo.\n\nDe qualquer forma, multo obrigado pelo feedback! 🖖🤖"))
        }
    }
}
