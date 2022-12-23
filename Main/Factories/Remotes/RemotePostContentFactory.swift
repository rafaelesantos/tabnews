//
//  RemotePostContentFactory.swift
//  Main
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation
import Data
import Domain

func makeRemoteAddPostContent() -> AddPostContent {
    RemoteAddPostContent(httpClient: makeNetworkAdapter(), httpEndpoint: InitContentEndpoint(method: .post))
}

func makeRemoteDeletePostContent(user: String, slug: String) -> DeletePostContent {
    RemoteDeletePostContent(httpClient: makeNetworkAdapter(), httpEndpoint: ContentDataEndpoint(method: .patch, user: user, slug: slug))
}

func makeRemoteAnswer() -> AddAnswer {
    RemoteAddAnswer(httpClient: makeNetworkAdapter(), httpEndpoint: InitContentEndpoint(method: .post))
}
