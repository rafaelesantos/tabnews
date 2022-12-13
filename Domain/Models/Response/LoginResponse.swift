//
//  LoginResponse.swift
//  Domain
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation

public struct LoginResponse: TabNewsModel {
    public let id: String
    public let token: String
    public let expires_at: String
    public let created_at: String
    public let updated_at: String
}
