//
//  AddSignup.swift
//  Domain
//
//  Created by Rafael Santos on 22/12/22.
//

import Foundation

public protocol AddSignup {
    typealias Result = Swift.Result<UserResponse, TabNewsError>
    func addSignup(withBody requestBody: SignupRequest) async -> Result
}
