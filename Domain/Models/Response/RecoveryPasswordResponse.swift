//
//  RecoveryPasswordResponse.swift
//  Domain
//
//  Created by Rafael Santos on 18/12/22.
//

import Foundation

public struct RecoveryPasswordResponse: TabNewsModel {
    public let used: Bool
    public let expires_at: String
    public let created_at: String
    public let updated_at: String
}
