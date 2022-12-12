//
//  GetContentData.swift
//  Domain
//
//  Created by Rafael Santos on 11/12/22.
//

import Foundation

public protocol GetContentData {
    typealias Result = Swift.Result<InitContentResponse, TabNewsError>
    func getContentData() async -> Result
}
