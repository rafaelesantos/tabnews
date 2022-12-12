//
//  RemoteGetStatus.swift
//  Data
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation
import Domain

public final class RemoteGetStatus: GetStatus, TabNewsHttpRequest {
    public typealias Response = StatusResponse
    public var httpClient: TabNewsHttpClient
    public var httpEndpoint: TabNewsHttpEndpoint
    
    public init(httpClient: TabNewsHttpClient, httpEndpoint: TabNewsHttpEndpoint) {
        self.httpClient = httpClient
        self.httpEndpoint = httpEndpoint
    }
    
    public func getStatus() async -> GetStatus.Result {
        let result = await httpClient.request(self)
        switch result {
        case .success(let response): return .success(response)
        case .failure(let httpError): return .failure(.requestError(error: httpError))
        }
    }
    
    public func decode(_ data: Data, endpoint: TabNewsHttpEndpoint?) throws -> Response {
        let jsonDecoder = JSONDecoder()
        guard let decoded: Response = try? jsonDecoder.decode(Response.self, from: data) else { throw TabNewsError.decodedError(type: Response.self) }
        return decoded
    }
}