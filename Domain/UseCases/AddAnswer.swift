//
//  AddAnswer.swift
//  Domain
//
//  Created by Rafael Santos on 22/12/22.
//

import Foundation

public protocol AddAnswer {
    typealias Result = Swift.Result<InitContentResponse, TabNewsError>
    func addAnswer(withBody requestBody: AnswerRequest) async -> Result
}
