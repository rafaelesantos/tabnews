//
//  GetContentChildren.swift
//  Domain
//
//  Created by Rafael Santos on 12/12/22.
//

import Foundation

public protocol GetContentChildren {
    typealias Result = Swift.Result<[InitContentResponse], TabNewsError>
    func getContentChildren() async -> Result
}
