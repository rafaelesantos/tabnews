//
//  PostRecoveryPassword.swift
//  Domain
//
//  Created by Rafael Santos on 18/12/22.
//

import Foundation

public protocol PostRecoveryPassword {
    typealias Result = Swift.Result<RecoveryPasswordResponse, TabNewsError>
    func postRecoveryPassword(withBody requestBody: RecoveryPasswordRequest) async -> Result
}
