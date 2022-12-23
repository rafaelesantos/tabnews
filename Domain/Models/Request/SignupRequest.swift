//
//  SignupRequest.swift
//  Domain
//
//  Created by Rafael Santos on 22/12/22.
//

import Foundation

public struct SignupRequest: TabNewsModel {
    public let username: String
    public let email: String
    public let password: String
    
    public init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
}
