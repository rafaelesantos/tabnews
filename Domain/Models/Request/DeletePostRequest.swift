//
//  DeletePostRequest.swift
//  Domain
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation

public struct DeletePostRequest: TabNewsModel {
    public var status: String
    
    public init(status: String = "deleted") {
        self.status = status
    }
}
