//
//  AnswerRequest.swift
//  Domain
//
//  Created by Rafael Santos on 22/12/22.
//

import Foundation

public struct AnswerRequest: TabNewsModel {
    public var status: String
    public var body: String
    public var parent_id: String
    
    public init(
        status: String = "published",
        body: String,
        parent_id: String
    ) {
        self.status = status
        self.body = body
        self.parent_id = parent_id
    }
}

