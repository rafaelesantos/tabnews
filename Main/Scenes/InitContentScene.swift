//
//  InitContentView.swift
//  UserInterface
//
//  Created by Rafael Santos on 10/12/22.
//

import SwiftUI
import Presentation
import UserInterface

public struct InitContentScene: View {
    @State private var presenter: InitContentPresenterProtocol
    @State private var initContents: [InitContentViewModel] = []
    @State private var currentPage: Int = 1
    @State private var currentPerPage = 6 {
        didSet { Task { await loadData() } }
    }
    @State private var currentStrategy: InitContentEndpointStrategy = .relevant
    @State private var isRelevant: Bool = true {
        didSet {
            currentStrategy = isRelevant ? .relevant : .new
            Task { await loadData() }
        }
    }
    
    public init(presenter: InitContentPresenterProtocol) {
        self._presenter = State(initialValue: presenter)
    }
    
    public var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                if initContents.isEmpty { ProgressView() }
                else { contents(proxy: proxy) }
            }
            .navigationTitle("TabNews")
        }
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
            Section(content: {
                HStack {
                    Text("Relevant News")
                    Spacer()
                    Toggle("", isOn: Binding(get: { isRelevant }, set: { isRelevant = $0 }))
                }
                
                HStack {
                    Text("Contents Per Page")
                    Spacer()
                    Stepper("", value: Binding(get: { currentPerPage }, set: { currentPerPage = $0 }), in: 3...30)
                }
            }, header: {
                Text("Query Settings")
            })
            
            Section(content: {
                ForEach(initContents, id: \.id) { content in
                    if let user = content.owner_username, let slug = content.slug {
                        NavigationLink(destination: contentDataScene(content: content, user: user, slug: slug)) {
                            CardInitContentView(viewModel: content)
                        }
                    } else {
                        CardInitContentView(viewModel: content)
                    }
                }
            }, header: {
                Text("page \(currentPage) with \(currentPerPage) per page sort by \(currentStrategy.rawValue)")
            }, footer: {
                VStack(alignment: .center, spacing: 0) {
                    if !initContents.isEmpty { pagination(proxy: proxy) }
                }.padding(15)
            })
        }
        .listStyle(.insetGrouped)
        .refreshable { Task { await loadData() } }
        
    }
    
    private func contentDataScene(content: InitContentViewModel, user: String, slug: String) -> some View {
        ContentDataScene(presenter: makeContentDataPresenter(endpoint: ContentDataEndpoint(user: user, slug: slug)))
            .navigationTitle(content.title ?? "")
            .toolbar {
                if let user = content.owner_username {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            TagTabNewsView(user, color: .randomColor)
                        }
                    }
                }
            }
    }
    
    public func pagination(proxy: ScrollViewProxy) -> some View {
        PaginationTabNewsView(currentPage: currentPage) { page in
            currentPage = page
            withAnimation {
                guard let id = initContents.first?.id else { return }
                proxy.scrollTo(id, anchor: .top)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                Task { await loadData() }
            }
        }
    }
    
    private func loadData() async {
        presenter = makeInitContentPresenter(endpoint: InitContentEndpoint(page: currentPage, perPage: currentPerPage, strategy: currentStrategy))
        initContents = (try? await presenter.showInitContents()) ?? []
    }
}

struct InitContentScene_Previews: PreviewProvider {
    static var previews: some View {
        InitContentScene(presenter: makeInitContentPresenter())
    }
}
