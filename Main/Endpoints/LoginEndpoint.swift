//
//  LoginEndpoint.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Data

struct LoginEndpoint: TabNewsHttpEndpoint {
    var method: TabNewsHttpMethod = .post
    var scheme: TabNewsHttpScheme = .https
    var host: String = "www.tabnews.com.br"
    var path: String = "/api/v1/sessions"
    var queryItems: [URLQueryItem]?
    var headers: [TabNewsHttpHeader]?
    var body: Data?
}
