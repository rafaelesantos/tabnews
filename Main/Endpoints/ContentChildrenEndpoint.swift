//
//  ContentChildrenEndpoint.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Data

struct ContentChildrenEndpoint: TabNewsHttpEndpoint {
    var method: TabNewsHttpMethod = .get
    var scheme: TabNewsHttpScheme = .https
    var host: String = "www.tabnews.com.br"
    var path: String = "/api/v1/contents"
    var queryItems: [URLQueryItem]?
    var headers: [TabNewsHttpHeader]?
    var body: Data?
    
    public init(user: String, slug: String) {
        path += "/\(user)/\(slug)/children"
    }
}
