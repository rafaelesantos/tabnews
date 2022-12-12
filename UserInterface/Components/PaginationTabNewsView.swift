//
//  PaginationTabNewsView.swift
//  UserInterface
//
//  Created by Rafael Santos on 10/12/22.
//

import SwiftUI

public struct PaginationTabNewsView: View {
    @State private var pages: [Int]
    @State private(set) var currentPage: Int
    private var selectedPage: (Int) -> Void
    
    public init(currentPage: Int = 1, selectedPage: @escaping (Int) -> Void) {
        self.selectedPage = selectedPage
        var pages: [Int] = [1, 2, 3, 4]
        if pages.max() == currentPage {
            pages = pages.map({ $0 + 1 })
        } else if pages.min() == currentPage && (pages.min() ?? 0) > 1 {
            pages = pages.map({ $0 - 1 })
        }
        self.pages = pages
        self.currentPage = currentPage
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            Button {
                if currentPage > 1 { actionButtonPage(onPage: currentPage - 1) }
            } label: {
                Image(systemName: "chevron.left")
            }

            Spacer(minLength: 6)
            HStack {
                ForEach(pages, id: \.self) { makeButtonPage(with: $0) }
            }
            Spacer(minLength: 6)
            Button {
                actionButtonPage(onPage: currentPage + 1)
            } label: {
                Image(systemName: "chevron.right")
            }
            Spacer()
        }
        .padding(.horizontal, 30)
    }
    
    private func makeButtonPage(with page: Int) -> some View {
        Button(action: { actionButtonPage(onPage: page) }, label: {
            Text("\(page)")
                .font(.footnote)
                .foregroundColor(currentPage == page ? Color.blue : .primary)
                .frame(width: 40, height: 25)
                .background(currentPage == page ? Color.blue.opacity(0.2) : .clear)
                .cornerRadius(6)
        })
    }
    
    private func actionButtonPage(onPage page: Int) {
        selectedPage(page)
        pages = updatedPages(pages, page: page)
        currentPage = page
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
        PaginationTabNewsView(selectedPage: { _ in })
    }
}
