//
//  GetUser.swift
//  Domain
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation

public protocol GetUser {
    typealias Result = Swift.Result<UserResponse, TabNewsError>
    func getUser(token: String) async -> Result
}
