//
//  StatusResponse.swift
//  Domain
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation

public struct StatusResponse: TabNewsModel {
    public let updated_at: String
    public let dependencies: DependenciesStatusResponse
}

public struct DependenciesStatusResponse: TabNewsModel {
    public let database: DatabaseStatusResponse
    public let webserver: WebserverStatusResponse
}

public struct DatabaseStatusResponse: TabNewsModel {
    public let status: String
    public let max_connections: Int
    public let opened_connections: Int
    public let latency: LatencyStatusResponse
    public let version: String
}

public struct LatencyStatusResponse: TabNewsModel {
    public let first_query: Double
    public let second_query: Double
    public let third_query: Double
}

public struct WebserverStatusResponse: TabNewsModel {
    public let status: String
    public let provider: String
    public let environment: String
    public let aws_region: String
    public let vercel_region: String
    public let timezone: String
    public let last_commit_author: String
    public let last_commit_message: String
    public let last_commit_message_sha: String
    public let version: String
}
