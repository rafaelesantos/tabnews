//
//  GetInitContent.swift
//  Domain
//
//  Created by Rafael Santos on 09/12/22.
//

import Foundation

public protocol GetInitContent {
    typealias Result = Swift.Result<[InitContentResponse], TabNewsError>
    func get() async -> Result
}
