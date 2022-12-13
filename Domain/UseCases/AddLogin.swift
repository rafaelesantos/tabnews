//
//  AddLogin.swift
//  Domain
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation

public protocol AddLogin {
    typealias Result = Swift.Result<LoginResponse, TabNewsError>
    func addLogin(withBody requestBody: LoginRequest) async -> Result
}

