//
//  InitContentViewModel.swift
//  Presentation
//
//  Created by Rafael Santos on 09/12/22.
//

import Foundation

public struct InitContentViewModel {
    public var id: UUID = UUID()
    public let title: String?
    public let updated_at: Date?
    public let tabcoins: Int?
    public let owner_username: String?
}
