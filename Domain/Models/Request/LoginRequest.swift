//
//  LoginRequest.swift
//  Domain
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation

public struct LoginRequest: TabNewsModel {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
