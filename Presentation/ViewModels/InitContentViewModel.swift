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
    public let children_deep_count: Int?
    
    public init(title: String?, updated_at: Date?, tabcoins: Int?, owner_username: String?, children_deep_count: Int?) {
        self.title = title
        self.updated_at = updated_at
        self.tabcoins = tabcoins
        self.owner_username = owner_username
        self.children_deep_count = children_deep_count
    }
}
