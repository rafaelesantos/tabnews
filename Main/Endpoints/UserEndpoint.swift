//
//  UserEndpoint.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Data

struct UserEndpoint: TabNewsHttpEndpoint {
    var method: TabNewsHttpMethod = .get
    var scheme: TabNewsHttpScheme = .https
    var host: String = "www.tabnews.com.br"
    var path: String = "/api/v1/user"
    var queryItems: [URLQueryItem]?
    var headers: [TabNewsHttpHeader]?
    var body: Data?
    
    public init(user: String? = nil) {
        if let user = user { path += "s/\(user)" }
    }
}
