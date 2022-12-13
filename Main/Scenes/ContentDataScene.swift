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
        VStack {
            if let viewModel = viewModel, let body = viewModel.body?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) {
                List {
                    if !needLoading {
                        if let user = viewModel.owner_username {
                            Section {
                                NavigationLink(destination: makeInitContentScene(user: user)) {
                                    CardBasicDetailTagView(title: "Author Page", description: user)
                                }
                            }
                        }
                        
                        Section {
                            MarkdownView(text: body) { element in
                                ElementView(element: element)
                            }
                        } header: {
                            if let date = viewModel.updated_at?.asString(withDateFormat: "dd MMMM - HH:mm") {
                                Text(date)
                            }
                        }
                        
                        if let commentsAmount = viewModel.children_deep_count, commentsAmount > 0, let contentChildrenView = try? makeContentChildrenScene(viewModel: viewModel) {
                            Section {
                                NavigationLink(destination: contentChildrenView) {
                                    commentsInfo(commentsAmount: commentsAmount)
                                }
                            }
                        }
                    }
                }
                .refreshable { Task { await loadData() } }
                .listStyle(.insetGrouped)
                
            } else {
                ProgressTabNewsView()
            }
        }
        .navigationTitle(viewModel?.title ?? "")
        .task { await loadData() }
    }
    
    private func loadData() async {
        needLoading.toggle()
        viewModel = try? await presenter.showContentData()
        needLoading.toggle()
    }
    
    private func contentInfo(user: String, date: String) -> some View {
        Section {
            HStack {
                Text("Author")
                Spacer()
                Text(user.uppercased())
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("Update Date")
                Spacer()
                Text(date.uppercased())
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func commentsInfo(commentsAmount: Int) -> some View {
        HStack {
            Image(systemName: "ellipsis.message.fill")
                .foregroundColor(.blue.opacity(0.8))
            Text("Comments")
            Spacer()
            Text("\(commentsAmount > 0 ? "\(commentsAmount)" : "No Comments")")
                .font(.footnote)
                .bold()
                .foregroundColor(.secondary)
        }
    }
}

struct ContentDataScene_Previews: PreviewProvider {
    static let user = "GabrielSozinho"
    static let slug = "documentacao-da-api-do-tabnews"
    static var previews: some View {
        NavigationView {
            ContentDataScene(presenter: makeContentDataPresenter(endpoint: ContentDataEndpoint(user: user, slug: slug)))
        }
    }
}
