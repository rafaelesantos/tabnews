//
//  InitContentViewModel.swift
//  Presentation
//
//  Created by Rafael Santos on 09/12/22.
//

import Foundation
import Domain

public struct InitContentViewModel {
    public var id: UUID = UUID()
    public let title: String?
    public let updated_at: Date?
    public let tabcoins: Int?
    public let owner_username: String?
    public let children_deep_count: Int?
    public let slug: String?
    public var body: String?
    public let children: [InitContentViewModel]?
    
    public init(title: String?, updated_at: Date?, tabcoins: Int?, owner_username: String?, children_deep_count: Int?, slug: String?, body: String? = nil, children: [InitContentViewModel]? = nil) {
        self.title = title
        self.updated_at = updated_at
        self.tabcoins = tabcoins
        self.owner_username = owner_username
        self.children_deep_count = children_deep_count
        self.slug = slug
        self.body = body
        self.children = children
    }
    
    public init(response: InitContentResponse) {
        self.title = response.title
        
        var updatedAt = response.updated_at?.replacingOccurrences(of: "T", with: " ")
        for _ in 0...7 { _ = updatedAt?.removeLast() }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let updatedAtDate = dateFormatter.date(from: updatedAt ?? "")
        self.updated_at = updatedAtDate
        
        self.tabcoins = response.tabcoins
        self.owner_username = response.owner_username
        self.children_deep_count = response.children_deep_count
        self.slug = response.slug
        self.body = response.body
        self.children = response.children?.map({ InitContentViewModel(response: $0) })
    }
}
