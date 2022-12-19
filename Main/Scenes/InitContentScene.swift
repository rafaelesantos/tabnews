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
    @State private var needNavigationToAddPostContent = false
    private var user: String?
    
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
        .setTabMoney()
        .navigationDestination(isPresented: $needNavigationToAddPostContent, destination: { makeAddPostScene(username: loggedUsername) })
        .task {
            await loadData()
        }
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
                    ForEach(initContents, id: \.id) { content in
                        if let user = content.owner_username, let slug = content.slug {
                            NavigationLink(destination: makeContentDataScene(user: user, slug: slug)) {
                                if let _ = content.body {
                                    CardContentChildrenView(viewModel: content)
                                } else {
                                    CardInitContentView(viewModel: content)
                                }
                            }
                        } else {
                            CardInitContentView(viewModel: content)
                        }
                    }
                }
                
            }, header: {
                if needLoading {
                    ProgressTabNewsView().frame(height: 60)
                } else if initContents.isEmpty && notFoundData {
                    NotFoundTabNewsView(style: .astronaut)
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
}

struct InitContentScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InitContentScene(presenter: makeInitContentPresenter())
        }
    }
}
