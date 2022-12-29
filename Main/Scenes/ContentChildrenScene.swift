//
//  ContentChildrenScene.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import SwiftUI
import RefdsUI
import Presentation
import UserInterface

struct ContentChildrenScene: View {
    @State private var presenter: ContentChildrenPresenterProtocol
    @State private var previousViewModel: InitContentViewModel
    @State private var viewModel: [InitContentViewModel] = []
    @State private var needLoading: Bool = false
    @State private var needPresent: Bool = false
    @State private var queryString: String = ""
    @AppStorage("loggedUsername") var loggedUsername: String = ""
    @State @AppStorage("favoritContents") var favoritContents = [InitContentViewModel]()
    @State private var needNavigationShare = false
    @State private var shareSheetItems: [Any] = []
    
    init(previous: InitContentViewModel) throws {
        guard let user = previous.owner_username, let slug = previous.slug else { throw NSError(domain: "content.child", code: 1) }
        self._presenter = State(initialValue: makeContentChildrenPresenter(endpoint: ContentChildrenEndpoint(user: user, slug: slug)))
        self._previousViewModel = State(initialValue: previous)
    }
    
    var body: some View {
        List {
            Section {
                if let body = previousViewModel.body?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) {
                    HStack(spacing: 15) {
                        VStack {
                            Image(systemName: "chevron.up")
                                .foregroundColor(.yellow.opacity(0.5))
                            Spacer()
                            RefdsText("\(previousViewModel.tabcoins ?? 0)", size: .extraSmall, color: .yellow, weight: .bold)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.yellow.opacity(0.5))
                        }.padding(.vertical, 10)
                        
                        RefdsText(body.replacingOccurrences(of: "*", with: ""), lineLimit: 3)
                    }.disabled(true)
                }
                
                if let date = previousViewModel.updated_at?.asString(withDateFormat: "dd MMMM - HH:mm") {
                    CardBasicDetailView(title: "Data", description: date)
                        .disabled(true)
                }
            } header: {
                RefdsText("tópico anterior", size: .extraSmall, color: .secondary)
            }
            
            if needLoading {
                Section(content: { }, header: { ProgressTabNewsView() })
            }
            
            Section {
                ForEach(viewModel.filter({ searchContents(content: $0) }), id: \.id) { content in
                    if let username = content.owner_username, let slug = content.slug {
                        NavigationLink {
                            makeContentDataScene(user: username, slug: slug)
                        } label: {
                            CardContentChildrenView(viewModel: content)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    if loggedUsername == username { swipeDeleteButton(user: username, slug: slug) }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: false) { swipeAddFavoritButton(content: content) }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    if let url = URL(string: "https://tabnews.com.br/\(username)/\(slug)") {
                                        swipeShareButton(url: url)
                                    }
                                }
                        }
                    }
                }
            } header: {
                RefdsText("comentários", size: .extraSmall, color: .secondary)
            }
        }
        .refreshable { Task { await loadData() } }
        .task { await loadData() }
        .navigationTitle("Comentários")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { needPresent = true }, label: { RefdsTag(previousViewModel.owner_username ?? "", color: .randomColor) })
            }
        }
        .navigationDestination(isPresented: $needPresent, destination: { makeInitContentScene(user: previousViewModel.owner_username) })
        .searchable(text: $queryString, prompt: "Busque por comentário")
        .sheet(isPresented: $needNavigationShare, content: { ActivityViewController(activityItems: $shareSheetItems) })
    }
    
    private func commentsView(amount: Int) -> some View {
        CardBasicDetailView(title: "Comentários", description: "\(amount > 0 ? "\(amount)" : "Não há comentários")", image: "ellipsis.message.fill", imageColor: .blue)
    }
    
    private func loadData() async {
        viewModel = []
        needLoading.toggle()
        viewModel = (try? await presenter.showContentChildren()) ?? []
        needLoading.toggle()
    }
    
    private func searchContents(content: InitContentViewModel) -> Bool {
        let queryString = queryString.lowercased()
        if queryString.isEmpty { return true }
        let username = content.owner_username?.lowercased().contains(queryString) ?? false
        let body = content.body?.lowercased().contains(queryString) ?? false
        return username || body
    }
    
    private func deletePost(username: String, slug: String) async {
        needLoading.toggle()
        let presenterDeletePost = makeDeletePostContentPresenter(user: username, slug: slug)
        let _ = try? await presenterDeletePost.deletePostContent()
        needLoading.toggle()
        await loadData()
    }
    
    private func swipeDeleteButton(user: String, slug: String) -> some View {
        Button {
            Task { await deletePost(username: user, slug: slug) }
        } label: {
            Image(systemName: "trash.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
        .tint(.pink)
    }
    
    private func swipeAddFavoritButton(content: InitContentViewModel) -> some View {
        Button {
            if favoritContents.firstIndex(where: { $0.post_id == content.post_id }) == nil {
                favoritContents.append(content)
            }
        } label: {
            Image(systemName: "heart.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
        .tint(.teal)
    }
    
    private func swipeShareButton(url: URL) -> some View {
        Button {
            shareSheetItems = [url]
            needNavigationShare.toggle()
        } label: {
            Image(systemName: "square.and.arrow.up")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
        .tint(.orange)
    }
}

struct ContentChildrenScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            try? ContentChildrenScene(previous: InitContentViewModel(title: "any-title", updated_at: Date(), tabcoins: 28, owner_username: "GabrielSozinho", children_deep_count: 19, slug: "documentacao-da-api-do-tabnews", body: "Sim, eu estou fazendo isso. Mas é exatamente o que eu queria evitar, pois o front irá ficar processando **n** objetos e separando toda vez que fizer a request, o que dependendo da quantidade, pode `penalizar o desempenho`.\n\nSe tivesse essa opção para já vir filtrado somente as publicações, seria uma \"delicinha\" 😅\n\nMas como ainda não é possível, dá pra ir quebrando um galho dessa forma mesmo. Creio que não irá demorar pra ser implementado algo do tipo.\n\nDe qualquer forma, multo obrigado pelo feedback! 🖖🤖"))
        }
    }
}
