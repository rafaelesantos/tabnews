//
//  AddPostContent.swift
//  Domain
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation

public protocol AddPostContent {
    typealias Result = Swift.Result<InitContentResponse, TabNewsError>
    func addPostContent(withBody requestBody: NewPostRequest) async -> Result
}
