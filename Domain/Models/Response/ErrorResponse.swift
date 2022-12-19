//
//  ErrorResponse.swift
//  Domain
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation

public struct ErrorResponse: TabNewsModel {
    public let name: String?
    public let message: String?
    public let action: String?
    public let status_code: Int?
    public let error_id: String?
    public let request_id: String?
    public let error_location_code: String?
    public let key: String?
    public let type: String?
    
    public init(
        name: String? = nil,
        message: String? = nil,
        action: String? = nil,
        status_code: Int? = nil,
        error_id: String? = nil,
        request_id: String? = nil,
        error_location_code: String? = nil,
        key: String? = nil,
        type: String? = nil
    ) {
        self.name = name
        self.message = message
        self.action = action
        self.status_code = status_code
        self.error_id = error_id
        self.request_id = request_id
        self.error_location_code = error_location_code
        self.key = key
        self.type = type
    }
}
