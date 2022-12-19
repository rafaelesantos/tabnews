//
//  TabNewsError.swift
//  Domain
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation

public enum TabNewsError: Error {
    case response(error: ErrorResponse)
    
    var response: ErrorResponse {
        switch self {
        case .response(let error): return error
        }
    }
}
