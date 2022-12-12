//
//  AnalyticsUsersCreatedResponse.swift
//  Domain
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation

public struct AnalyticsUsersCreatedResponse: TabNewsModel {
    public let date: String
    public let cadastros: Int
    
    public init(date: String, cadastros: Int) {
        self.date = date
        self.cadastros = cadastros
    }
}
