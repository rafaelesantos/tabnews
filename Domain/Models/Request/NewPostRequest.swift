//
//  NewPostRequest.swift
//  Domain
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation

public struct NewPostRequest: TabNewsModel {
    public var status: String
    public var title: String
    public var body: String
    public var source_url: String?
    
    public init(
        status: String = "published",
        title: String,
        body: String,
        source_url: String? = nil
    ) {
        self.status = status
        self.title = title
        self.body = body
        self.source_url = source_url
    }
}
