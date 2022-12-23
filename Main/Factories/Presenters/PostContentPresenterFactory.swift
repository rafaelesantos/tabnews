//
//  PostContentPresenterFactory.swift
//  Main
//
//  Created by Rafael Santos on 19/12/22.
//

import Foundation
import Presentation

func makeAddPostContentPresenter() -> AddPostContentPresenterProtocol {
    AddPostContentPresenter(interactor: makeAddPostContentInteractor())
}

func makeDeletePostContentPresenter(user: String, slug: String) -> DeletePostContentPresenterProtocol {
    DeletePostContentPresenter(interactor: makeDeletePostContentInteractor(user: user, slug: slug))
}

func makeAnswerPresenter() -> AnswerPresenterProtocol {
    AnswerPresenter(interactor: makeAnswerInteractor())
}
