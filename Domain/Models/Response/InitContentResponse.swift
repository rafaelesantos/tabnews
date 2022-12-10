//
//  InitContentResponse.swift
//  Domain
//
//  Created by Rafael Santos on 09/12/22.
//

import Foundation

public struct InitContentResponse: TabNewsModel {
    let id: String
    let owner_id: String
    let parent_id: String?
    let slug: String
    let title: String
    let status: String
    let source_url: String?
    let created_at: Date?
    let updated_at: Date?
    let published_at: Date?
    let deleted_at: Date?
    let tabcoins: Int?
    let owner_username: String?
    let children_deep_count: Int?
}
