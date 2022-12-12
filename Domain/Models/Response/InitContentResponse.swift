//
//  InitContentResponse.swift
//  Domain
//
//  Created by Rafael Santos on 09/12/22.
//

import Foundation

public struct InitContentResponse: TabNewsModel {
    public let id: String?
    public let owner_id: String?
    public let slug: String?
    public let title: String?
    public let status: String?
    public let source_url: String?
    public let updated_at: String?
    public let tabcoins: Int?
    public let owner_username: String?
    public let children_deep_count: Int?
    public let body: String?
    public let children: [InitContentResponse]?
    
    public init(id: String? = nil, owner_id: String? = nil, slug: String? = nil, title: String? = nil, status: String? = nil, source_url: String? = nil, updated_at: String? = nil, tabcoins: Int? = nil, owner_username: String? = nil, children_deep_count: Int? = nil, body: String? = nil, children: [InitContentResponse]? = nil) {
        self.id = id
        self.owner_id = owner_id
        self.slug = slug
        self.title = title
        self.status = status
        self.source_url = source_url
        self.updated_at = updated_at
        self.tabcoins = tabcoins
        self.owner_username = owner_username
        self.children_deep_count = children_deep_count
        self.body = body
        self.children = children
    }
}
