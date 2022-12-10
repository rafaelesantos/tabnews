//
//  InitContentResponse.swift
//  Domain
//
//  Created by Rafael Santos on 09/12/22.
//

import Foundation

public struct InitContentResponse: TabNewsModel {
    public let id: String
    public let owner_id: String
    public let parent_id: String?
    public let slug: String
    public let title: String
    public let status: String
    public let source_url: String?
    public let created_at: Date?
    public let updated_at: Date
    public let published_at: Date?
    public let deleted_at: Date?
    public let tabcoins: Int?
    public let owner_username: String?
    public let children_deep_count: Int?
}
