//
//  ContentDataScene.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import SwiftUI
import Presentation
import UserInterface
import Markdown

struct ContentDataScene: View {
    @State private var presenter: ContentDataPresenterProtocol
    @State private var viewModel: InitContentViewModel?
    @State private var needLoading: Bool = false
    @State private var needNavigation: Bool = false
    
    public init(presenter: ContentDataPresenterProtocol) {
        self._presenter = State(initialValue: presenter)
    }
    
    var body: some View {
        VStack { listContents }
        .task { await loadData() }
        .navigationTitle(viewModel?.title ?? "")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let username = viewModel?.owner_username { author(username: username) }
            }
        }
        .navigationDestination(isPresented: $needNavigation, destination: {
            if let username = viewModel?.owner_username { makeInitContentScene(user: username) }
        })
    }
    
    private var listContents: some View {
        List {
            sectionBody
            sectionComments
        }
        .refreshable { Task { await loadData() } }
        .listStyle(.insetGrouped)
    }
    
    private func author(username: String) -> some View {
        Button(action: { needNavigation = true }, label: { TagTabNewsView(username, color: .randomColor) })
    }
    
    private var sectionBody: some View {
        Section {
            if let body = viewModel?.body?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) {
                MarkdownView(text: body) { element in
                    ElementView(element: element)
                }
            }
        } header: {
            if needLoading {
                Spacer()
                ProgressTabNewsView()
            } else if let date = viewModel?.updated_at?.asString(withDateFormat: "dd MMMM - HH:mm") {
                Text(date)
            }
        }
    }
    
    private var sectionComments: some View {
        Section {
            if let viewModel = viewModel, let commentsAmount = viewModel.children_deep_count, commentsAmount > 0, let contentChildrenView = try? makeContentChildrenScene(viewModel: viewModel) {
                NavigationLink(destination: contentChildrenView) {
                    commentsView(commentsAmount: commentsAmount)
                }
            }
        }
    }
    
    private func loadData() async {
        viewModel?.body = nil
        needLoading.toggle()
        viewModel = try? await presenter.showContentData()
        needLoading.toggle()
    }
    
    private func commentsView(commentsAmount: Int) -> some View {
        CardBasicDetailView(title: "Comentários", description: "\(commentsAmount > 0 ? "\(commentsAmount)" : "Não há comentários")", image: "ellipsis.message.fill", imageColor: .blue)
    }
}

struct ContentDataScene_Previews: PreviewProvider {
    static let user = "GabrielSozinho"
    static let slug = "documentacao-da-api-do-tabnews"
    static var previews: some View {
        NavigationStack {
            ContentDataScene(presenter: makeContentDataPresenter(endpoint: ContentDataEndpoint(user: user, slug: slug)))
        }
    }
}
