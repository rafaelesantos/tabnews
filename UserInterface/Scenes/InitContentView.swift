//
//  InitContentView.swift
//  UserInterface
//
//  Created by Rafael Santos on 10/12/22.
//

import SwiftUI
import Data
import Presentation
import Infrastructure
import RefdsDomain

public struct InitContentView: View {
    @State private var presenter: InitContentPresenterProtocol
    @State private var initContents: [InitContentViewModel] = []
    @State private var currentPage: Int = 1
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
            .task { await loadData() }
            .navigationTitle("TabNews")
        }
    }
    
    public func relevantContents() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .center, spacing: 12) {
                ForEach(initContents, id: \.id) { content in
                    CardInitContentView(viewModel: content)
                        .frame(width: 250)
                        .frame(maxHeight: 150)
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
            }
            
            Section(content: {
                ForEach(initContents, id: \.id) { content in
                    CardInitContentView(viewModel: content)
                }
            }, header: {
                Text("page \(currentPage) sort by \(currentStrategy.rawValue)")
            }, footer: {
                VStack(alignment: .center, spacing: 0) {
                    if !initContents.isEmpty { pagination(proxy: proxy) }
                }.padding(15)
            })
        }
        .listStyle(.insetGrouped)
        .refreshable { Task { await loadData() } }
        
    }
    
    public func pagination(proxy: ScrollViewProxy) -> some View {
        PaginationTabNewsView(amountPagesView: 5, currentPage: currentPage) { page in
            currentPage = page
            withAnimation {
                guard let id = initContents.first?.id else { return }
                proxy.scrollTo(id, anchor: .top)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                Task { await loadData() }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func loadData() async {
        presenter = await InitContentView_Previews.makePresenter(page: currentPage, strategy: currentStrategy)
        initContents = (try? await presenter.showInitContents()) ?? []
    }
}

struct InitContentView_Previews: PreviewProvider {
    public final class InitContentRouter: InitContentRouterProtocol {}
    
    static func makePresenter(page: Int = 1, strategy: InitContentEndpointStrategy = .relevant) -> InitContentPresenterProtocol {
        let httpClient = TabNewsNetworkAdapter()
        let httpEnpoint = InitContentEndpoint(page: page, strategy: strategy)
        let useCase = RemoteGetInitContent(httpClient: httpClient, httpEndpoint: httpEnpoint)
        let interactor = InitContentInteractor(useCase: useCase)
        let router = InitContentRouter()
        return InitContentPresenter(interactor: interactor, router: router)
    }
    
    static var previews: some View {
        InitContentView(presenter: makePresenter())
    }
}
