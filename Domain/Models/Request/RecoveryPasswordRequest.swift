//
//  RecoveryPasswordRequest.swift
//  Domain
//
//  Created by Rafael Santos on 18/12/22.
//

import Foundation

public struct RecoveryPasswordRequest: TabNewsModel {
    public var username: String?
    public var email: String?
    
    public init(username: String? = nil, email: String? = nil) {
        self.username = username
        self.email = email
    }
}
