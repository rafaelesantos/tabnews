//
//  UserResponse.swift
//  Domain
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation

public struct UserResponse: Hashable, TabNewsModel {
    public let id: String
    public let username: String
    public let email: String?
    public let notifications: Bool?
    public let features: [String]
    public let tabcoins: Int
    public let tabcash: Int
    public let created_at: String
    public let updated_at: String
}
