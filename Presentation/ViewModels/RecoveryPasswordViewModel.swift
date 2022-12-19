//
//  RecoveryPasswordViewModel.swift
//  Presentation
//
//  Created by Rafael Santos on 18/12/22.
//

import Foundation
import Domain

public struct RecoveryPasswordViewModel {
    public let response: RecoveryPasswordResponse
    
    public init(response: RecoveryPasswordResponse) {
        self.response = response
    }
}
