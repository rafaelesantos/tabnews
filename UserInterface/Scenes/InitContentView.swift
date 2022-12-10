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

public struct InitContentView: View {
    private let presenter: InitContentPresenterProtocol
    @State private var initContents: [InitContentViewModel] = []
    
    public init(presenter: InitContentPresenterProtocol) {
        self.presenter = presenter
    }
    
    public var body: some View {
        List(initContents, id: \.id) { content in
            Text(content.title ?? "")
        }.task {
            initContents = (try? await presenter.showInitContents()) ?? []
        }
    }
}

struct InitContentView_Previews: PreviewProvider {
    public struct InitContentEndpoint: TabNewsHttpEndpoint {
        public var method: TabNewsHttpMethod = .get
        public var scheme: TabNewsHttpScheme = .https
        public var host: String = "www.tabnews.com.br"
        public var path: String = "/api/v1/contents"
        public var queryItems: [URLQueryItem]? = [
            .init(name: "page", value: "1"),
            .init(name: "per_page", value: "20"),
            .init(name: "strategy", value: "relevant")
        ]
        public var headers: [TabNewsHttpHeader]?
        public var body: Data?
        
        public init() { }
    }
    
    public final class InitContentRouter: InitContentRouterProtocol {}
    
    static func makePresenter() -> InitContentPresenterProtocol {
        let httpClient = TabNewsNetworkAdapter()
        let httpEnpoint = InitContentEndpoint()
        let useCase = RemoteGetInitContent(httpClient: httpClient, httpEndpoint: httpEnpoint)
        let interactor = InitContentInteractor(useCase: useCase)
        let router = InitContentRouter()
        return InitContentPresenter(interactor: interactor, router: router)
    }
    
    static var previews: some View {
        InitContentView(presenter: makePresenter())
    }
}
