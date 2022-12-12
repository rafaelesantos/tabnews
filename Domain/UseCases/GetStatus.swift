//
//  GetStatus.swift
//  Domain
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation

public protocol GetStatus {
    typealias Result = Swift.Result<StatusResponse, TabNewsError>
    func getStatus() async -> Result
}
