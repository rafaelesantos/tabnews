//
//  LoginViewModel.swift
//  Presentation
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Domain

public struct LoginViewModel {
    public var response: LoginResponse
    
    public init(response: LoginResponse) {
        self.response = response
    }
}
