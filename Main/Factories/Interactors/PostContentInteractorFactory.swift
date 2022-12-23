//
//  PostContentInteractorFactory.swift
//  Main
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation
import Presentation

func makeAddPostContentInteractor() -> AddPostContentInteractorProtocol {
    AddPostContentInteractor(useCase: makeRemoteAddPostContent())
}

func makeDeletePostContentInteractor(user: String, slug: String) -> DeletePostContentInteractorProtocol {
    DeletePostContentInteractor(useCase: makeRemoteDeletePostContent(user: user, slug: slug))
}

func makeAnswerInteractor() -> AnswerInteractorProtocol {
    AnswerInteractor(useCase: makeRemoteAnswer())
}
