//
//  UserViewModel.swift
//  Presentation
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation
import Domain

public struct UserViewModel: Hashable, Identifiable, Codable {
    public var id: UUID = UUID()
    public var response: UserResponse
    
    public init(response: UserResponse) {
        self.response = response
    }
    
    public static func == (lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        return lhs.response.id == rhs.response.id
    }
}
