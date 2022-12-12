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
    
    public init(presenter: ContentDataPresenterProtocol) {
        self._presenter = State(initialValue: presenter)
    }
    
    var body: some View {
        VStack {
            if let viewModel = viewModel, let body = viewModel.body?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) {
                List {
                    if let date = viewModel.updated_at?.asString(withDateFormat: "dd MMMM"), let user = viewModel.owner_username {
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
                    MarkdownView(text: body) { element in
                        ElementView(element: element)
                    }
                    .padding()
                    
                    if let commentsAmount = viewModel.children_deep_count {
                        Section {
                            HStack {
                                Image(systemName: "ellipsis.message.fill")
                                    .foregroundColor(.randomColor)
                                Text("Comments")
                                Spacer()
                                Text("\(commentsAmount)")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(.secondary)
                            }
                            
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .task { viewModel = try? await presenter.showContentData() }
    }
}

struct ContentDataScene_Previews: PreviewProvider {
    static var previews: some View {
        ContentDataScene(presenter: makeContentDataPresenter(endpoint: ContentDataEndpoint(user: "GabrielSozinho", slug: "documentacao-da-api-do-tabnews")))
    }
}
