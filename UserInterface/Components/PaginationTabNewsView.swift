//
//  PaginationTabNewsView.swift
//  UserInterface
//
//  Created by Rafael Santos on 10/12/22.
//

import SwiftUI

struct PaginationTabNewsView: View {
    @State private var pages: [Int]
    @State private(set) var currentPage: Int
    private var amountPagesView: Int
    private var selectedPage: (Int) -> Void
    
    init(amountPagesView: Int, currentPage: Int = 1, selectedPage: @escaping (Int) -> Void) {
        self.amountPagesView = amountPagesView
        self.selectedPage = selectedPage
        var pages: [Int] = [1]
        for page in 2...amountPagesView { pages.append(page) }
        if pages.max() == currentPage {
            pages = pages.map({ $0 + 1 })
        } else if pages.min() == currentPage && (pages.min() ?? 0) > 1 {
            pages = pages.map({ $0 - 1 })
        }
        self.pages = pages
        self.currentPage = currentPage
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            HStack {
                ForEach(pages, id: \.self) { page in
                    Button(action: {
                        selectedPage(page)
                        pages = updatedPages(pages, page: page)
                        currentPage = page
                    }, label: {
                        Text("\(page)")
                            .foregroundColor(currentPage == page ? Color.blue : .primary)
                            .frame(width: 50, height: 30)
                            .background(currentPage == page ? Color.blue.opacity(0.2) : .clear)
                            .cornerRadius(6)
                    })
                }
            }
            .padding(6)
        }
        .padding(.horizontal, 10)
    }
    
    private func updatedPages(_ pages: [Int], page: Int) -> [Int] {
        var pages = pages
        if pages.max() == page {
            pages = pages.map({ $0 + 1 })
        } else if pages.min() == page && (pages.min() ?? 0) > 1 {
            pages = pages.map({ $0 - 1 })
        }
        return pages
    }
}

struct PaginationTabNewsView_Previews: PreviewProvider {
    static var previews: some View {
        PaginationTabNewsView(amountPagesView: 6, selectedPage: { _ in })
    }
}
