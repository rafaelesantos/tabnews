//
//  InitContentEndpoint.swift
//  Main
//
//  Created by Rafael Santos on 10/12/22.
//

import Foundation
import Data

struct InitContentEndpoint: TabNewsHttpEndpoint {
    var method: TabNewsHttpMethod = .get
    var scheme: TabNewsHttpScheme = .https
    var host: String = "www.tabnews.com.br"
    var path: String = "/api/v1/contents"
    var queryItems: [URLQueryItem]?
    var headers: [TabNewsHttpHeader]?
    var body: Data?
    
    public init(page: Int = 1, perPage: Int = 20, strategy: InitContentEndpointStrategy = .relevant) {
        self.queryItems = [
            .init(name: "page", value: "\(page)"),
            .init(name: "per_page", value: "\(perPage)"),
            .init(name: "strategy", value: strategy.rawValue)
        ]
    }
}

enum InitContentEndpointStrategy: String {
    case relevant = "relevant"
    case new = "new"
}
