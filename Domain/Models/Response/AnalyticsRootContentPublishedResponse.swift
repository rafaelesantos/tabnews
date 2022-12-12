//
//  AnalyticsRootContentPublishedResponse.swift
//  Domain
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation

public struct AnalyticsRootContentPublishedResponse: TabNewsModel {
    public let date: String
    public let conteudos: Int
    
    public init(date: String, conteudos: Int) {
        self.date = date
        self.conteudos = conteudos
    }
}
