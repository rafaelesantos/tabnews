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
    @State private var canChangeToNextPage: Bool = false
    @State private var notFoundData: Bool = false
    @State private var currentPage: Int = 1
    @State private var currentPerPage = 5 {
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
    private var user: String?
    @AppStorage("coin") private var coin: String = ""
    @AppStorage("cash") private var cash: String = ""
    
    public init(presenter: InitContentPresenterProtocol, user: String? = nil) {
        self._presenter = State(initialValue: presenter)
        self.user = user
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            contents(proxy: proxy)
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                if needLoading {
                    ProgressView() 
                } else {
                    Button { } label: { TagTabNewsView(currentStrategy.rawValue, color: .randomColor) }
                }
            }
            
            if !coin.isEmpty, !cash.isEmpty {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(uiImage: UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .background(Color.blue)
                                .cornerRadius(4)
                            Text(coin)
                                .foregroundColor(.primary)
                                .font(.footnote)
                            Image(uiImage: UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .background(Color.green)
                                .cornerRadius(4)
                            Text(cash)
                                .foregroundColor(.primary)
                                .font(.footnote)
                        }
                    }
                }
            }
        })
        .navigationTitle(user == nil ? "TabNews" : user ?? "")
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
            Section {
                HStack {
                    Text("Relevant News")
                    Spacer()
                    Toggle("", isOn: Binding(get: { isRelevant }, set: { isRelevant = $0 }))
                }
                if let user = user {
                    NavigationLink {
                        makeUserScene(user: user)
                    } label: {
                        CardBasicDetailView(title: "Author Information", description: "", image: "person.crop.circle", imageColor: .randomColor)
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
                if initContents.isEmpty && notFoundData {
                    LottieView(name: "NotFount2")
                        .frame(height: 250)
                }
                else {
                    Text("page \(currentPage) with \(currentPerPage) per page sort by \(currentStrategy.rawValue)")
                }
            })
            
            if !(initContents.isEmpty && notFoundData) {
                Section {
                    HStack {
                        Text("Contents Per Page")
                        Spacer()
                        Picker("", selection: Binding(get: { currentPerPage }, set: { currentPerPage = $0 })) {
                            ForEach(0 ..< 31) { page in
                                if page % 5 == 0 && page != 0 { Text("\(page)") }
                            }
                        }
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
            InitContentScene(presenter: makeInitContentPresenter(), user: "GabrielSozinho")
        }
    }
}
