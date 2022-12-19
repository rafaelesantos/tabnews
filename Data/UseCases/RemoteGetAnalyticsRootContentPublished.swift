//
//  RemoteGetAnalyticsRootContentPublished.swift
//  Data
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Domain

public final class RemoteGetAnalyticsRootContentPublished: GetAnalyticsRootContentPublished, TabNewsHttpRequest {
    public typealias Response = [AnalyticsRootContentPublishedResponse]
    public var httpClient: TabNewsHttpClient
    public var httpEndpoint: TabNewsHttpEndpoint
    
    public init(httpClient: TabNewsHttpClient, httpEndpoint: TabNewsHttpEndpoint) {
        self.httpClient = httpClient
        self.httpEndpoint = httpEndpoint
    }
    
    public func getAnalyticsRootContentPublished() async -> GetAnalyticsRootContentPublished.Result {
        let result = await httpClient.request(self)
        switch result {
        case .success(let response): return .success(response)
        case .failure(let httpError): return .failure(.response(error: .init(message: httpError.description)))
        }
    }
    
    public func decode(_ data: Data, endpoint: TabNewsHttpEndpoint?) throws -> Response {
        let jsonDecoder = JSONDecoder()
        guard let decoded: Response = try? jsonDecoder.decode(Response.self, from: data) else {
            guard let decodedError: ErrorResponse = try? jsonDecoder.decode(ErrorResponse.self, from: data) else { throw TabNewsError.response(error: .init()) }
            throw TabNewsError.response(error: decodedError)
        }
        return decoded
    }
}
