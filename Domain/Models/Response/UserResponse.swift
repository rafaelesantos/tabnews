//
//  UserResponse.swift
//  Domain
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation

public struct UserResponse: TabNewsModel {
    public let id: String
    public let username: String
    public let features: [String]
    public let tabcoins: Int
    public let tabcash: Int
    public let created_at: String
    public let updated_at: String
}
