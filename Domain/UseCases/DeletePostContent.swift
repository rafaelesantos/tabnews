//
//  DeletePostContent.swift
//  Domain
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation

public protocol DeletePostContent {
    typealias Result = Swift.Result<InitContentResponse, TabNewsError>
    func deletePostContent(withBody requestBody: DeletePostRequest) async -> Result
}
