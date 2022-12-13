//
//  UserViewModel.swift
//  Presentation
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Domain

public struct UserViewModel {
    public var response: UserResponse
    
    public init(response: UserResponse) {
        self.response = response
    }
}
