//
//  InitContentView.swift
//  UserInterface
//
//  Created by Rafael Santos on 10/12/22.
//

import SwiftUI
import Presentation
import UserInterface
import RefdsUI

public struct InitContentScene: View {
    @State private var presenter: InitContentPresenterProtocol
    @State private var presenterDeletePost: DeletePostContentPresenterProtocol?
    @State private var initContents: [InitContentViewModel] = []
    @State private var canChangeToNextPage: Bool = false
    @State private var notFoundData: Bool = false
    @State private var currentPage: Int = 1
    @State private var currentPerPage = 10 {
        didSet { Task { await loadData() } }
    }
    @State private var currentStrategy: InitContentEndpointStrategy = .relevant
    @State private var isRelevant: Bool = true {
        didSet {
            currentStrategy = isRelevant ? .relevant : .new
            Task { await loadData() }
        }
    }
    @State private var needLoading: Bool = false
    @AppStorage("loggedUsername") var loggedUsername: String = ""
    @State @AppStorage("favoritContents") var favoritContents = [InitContentViewModel]()
    @State private var needNavigationToAddPostContent = false
    private var user: String?
    @State private var queryString: String = ""
    @State private var shareSheetItems: [Any] = []
    @State private var needNavigationShare = false
    
    public init(presenter: InitContentPresenterProtocol, user: String? = nil) {
        self._presenter = State(initialValue: presenter)
        self.user = user
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            contents(proxy: proxy)
        }
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack {
                    let color: Color = .randomColor
                    Button { isRelevant.toggle() } label: { RefdsTag(currentStrategy.rawValue, color: color) }
                    if !loggedUsername.isEmpty {
                        Button { needNavigationToAddPostContent.toggle() } label: {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                                .bold()
                        }
                    }
                }
            }
        })
        .navigationTitle(user == nil ? "TabNews" : user ?? "")
        .setTabMoney(isPresented: user == nil)
        .navigationDestination(isPresented: $needNavigationToAddPostContent, destination: { makeAddPostScene(username: loggedUsername) })
        .task {
            await loadData()
        }
        .searchable(text: $queryString, prompt: "Busque por conteúdo carregado")
        .sheet(isPresented: $needNavigationShare, content: { ActivityViewController(activityItems: $shareSheetItems) })
    }
    
    public func relevantContents() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .center, spacing: 12) {
                ForEach(initContents, id: \.id) { content in
                    VStack {
                        CardInitContentView(viewModel: content)
                            .frame(width: 250)
                            .frame(maxHeight: 150)
                    }
                }
            }
            .padding()
        }
    }
    
    public func contents(proxy: ScrollViewProxy) -> some View {
        List {
            if let user = user {
                Section {
                    NavigationLink {
                        makeUserScene(user: user)
                    } label: {
                        CardBasicDetailView(title: "Informações do autor", description: "", image: "person.crop.circle.fill", imageColor: .randomColor)
                    }
                }
            }
            
            Section(content: {
                if needLoading {
                    
                } else {
                    ForEach(initContents.filter({ searchContents(content: $0) }), id: \.id) { content in
                        if let user = content.owner_username, let slug = content.slug {
                            NavigationLink(destination: makeContentDataScene(user: user, slug: slug)) {
                                if let _ = content.body {
                                    CardContentChildrenView(viewModel: content)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            if loggedUsername == user { swipeDeleteButton(user: user, slug: slug) }
                                        }
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) { swipeAddFavoritButton(content: content) }
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            if let username = content.owner_username, let slug = content.slug, let url = URL(string: "https://tabnews.com.br/\(username)/\(slug)") {
                                                swipeShareButton(url: url)
                                            }
                                        }
                                } else {
                                    CardInitContentView(viewModel: content)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            if loggedUsername == user { swipeDeleteButton(user: user, slug: slug) }
                                        }
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) { swipeAddFavoritButton(content: content) }
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            if let username = content.owner_username, let slug = content.slug, let url = URL(string: "https://tabnews.com.br/\(username)/\(slug)") {
                                                swipeShareButton(url: url)
                                            }
                                        }
                                }
                            }
                        } else {
                            CardInitContentView(viewModel: content)
                                .swipeActions(edge: .leading, allowsFullSwipe: false) { swipeAddFavoritButton(content: content) }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    if let username = content.owner_username, let slug = content.slug, let url = URL(string: "https://tabnews.com.br/\(username)/\(slug)") {
                                        swipeShareButton(url: url)
                                    }
                                }
                        }
                    }
                }
                
            }, header: {
                if needLoading {
                    ProgressTabNewsView().frame(height: 60)
                } else if initContents.isEmpty && notFoundData {
                    NotFoundTabNewsView(style: .floating)
                }
                else {
                    RefdsText("página \(currentPage) com \(currentPerPage) por página ordenado por \(currentStrategy.rawValue)", size: .extraSmall, color: .secondary)
                }
            })
            
            if !(initContents.isEmpty && notFoundData) {
                Section {
                    Picker(selection: Binding(get: { currentPerPage }, set: { currentPerPage = $0 })) {
                        ForEach(0 ..< 31) { page in
                            if page % 5 == 0 && page != 0 { RefdsText("\(page)", size: .normal) }
                        }
                    } label: {
                        RefdsText("Conteúdos por página", size: .normal)
                    }
                } footer: {
                    VStack(alignment: .center, spacing: 0) {
                        if !initContents.isEmpty { pagination(proxy: proxy) }
                    }.padding(15)
                }
            }
        }
        .listStyle(.insetGrouped)
        .refreshable { Task { await loadData() } }
        
    }
    
    public func pagination(proxy: ScrollViewProxy) -> some View {
        PaginationTabNewsView(currentPage: currentPage, canChangeToNextPage: { canChangeToNextPage }) { page in
            currentPage = page
            Task { await loadData() }
        }
    }
    
    private var progressView: some View { return ProgressTabNewsView() }
    
    private func loadData() async {
        needLoading.toggle()
        notFoundData = false
        presenter = makeInitContentPresenter(endpoint: InitContentEndpoint(page: currentPage, perPage: currentPerPage, strategy: currentStrategy, user: user))
        initContents = (try? await presenter.showInitContents()) ?? []
        notFoundData = initContents.isEmpty
        DispatchQueue.main.async {
            canChangeToNextPage = currentPerPage <= initContents.count
            needLoading.toggle()
        }
    }
    
    private func deletePost(username: String, slug: String) async {
        needLoading.toggle()
        presenterDeletePost = makeDeletePostContentPresenter(user: username, slug: slug)
        let _ = try? await presenterDeletePost?.deletePostContent()
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
    
    private func searchContents(content: InitContentViewModel) -> Bool {
        let queryString = queryString.lowercased()
        if queryString.isEmpty { return true }
        let username = content.owner_username?.lowercased().contains(queryString) ?? false
        let title = content.title?.lowercased().contains(queryString) ?? false
        let body = content.body?.lowercased().contains(queryString) ?? false
        return username || title || body
    }
}

struct InitContentScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InitContentScene(presenter: makeInitContentPresenter())
        }
    }
}
