//
//  ContentDataScene.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import SwiftUI
import RefdsUI
import Presentation
import UserInterface
import MarkdownView

struct ContentDataScene: View {
    @State private var isPreview = false
    @State private var presenter: ContentDataPresenterProtocol
    @State private var viewModel: InitContentViewModel?
    @State private var needLoading: Bool = false
    @State private var needNavigation: Bool = false
    @State private var postBody: String = ""
    @AppStorage("loggedUsername") var loggedUsername: String = ""
    @State private var needLoadingAnswer: Bool = false
    @State private var needNavigationComments: Bool = false
    @State private var bodyContent: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    public init(presenter: ContentDataPresenterProtocol) {
        self._presenter = State(initialValue: presenter)
    }
    
    var body: some View {
        VStack { listContents }
        .task { await loadData() }
        .navigationTitle(viewModel?.title ?? "Comentário")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack {
                    if let username = viewModel?.owner_username { author(username: username) }
                    if !loggedUsername.isEmpty, let slug = viewModel?.slug, loggedUsername == viewModel?.owner_username {
                        Button { Task { await deletePost(slug: slug) } } label: {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.pink)
                                .bold()
                                .padding(5)
                                .background(.pink.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                }
            }
        }
        .navigationDestination(isPresented: $needNavigation, destination: {
            if let username = viewModel?.owner_username { makeInitContentScene(user: username) }
        })
        .navigationDestination(isPresented: $needNavigationComments) {
            if let viewModel = viewModel, let contentChildrenView = try? makeContentChildrenScene(viewModel: viewModel) { contentChildrenView }
        }
    }
    
    private var listContents: some View {
        List {
            sectionBody
            if let viewModel = viewModel, let commentsAmount = viewModel.children_deep_count, commentsAmount > 0 {  sectionComments }
            if !loggedUsername.isEmpty, viewModel?.post_id != nil { sectionAnswer }
        }
        .refreshable { Task { await loadData() } }
        .listStyle(.insetGrouped)
    }
    
    private func author(username: String) -> some View {
        Button(action: { needNavigation = true }, label: { RefdsTag(username, color: .randomColor) })
    }
    
    private var sectionBody: some View {
        Section {
            MarkdownView(text: $bodyContent)
                .lineSpacing(10)
                .font(.custom("Moderat-Regular", size: 16))
        } header: {
            if needLoading {
                Spacer()
                ProgressTabNewsView()
            } else if let date = viewModel?.updated_at?.asString(withDateFormat: "dd MMMM - HH:mm") {
                RefdsText(date, size: .extraSmall, color: .secondary)
            }
        }
    }
    
    private var sectionComments: some View {
        Section {
            if let viewModel = viewModel, let commentsAmount = viewModel.children_deep_count, commentsAmount > 0, let contentChildrenView = try? makeContentChildrenScene(viewModel: viewModel) {
                NavigationLink { contentChildrenView } label: {
                    commentsView(commentsAmount: commentsAmount)
                }
            }
        }
    }
    
    private var sectionAnswer: some View {
        Section {
            if isPreview {
                MarkdownView(text: postBody)
                    .lineSpacing(10)
                    .font(.custom("Moderat-Regular", size: 16))
            } else {
                TextField("Informe a resposta da postagem", text: $postBody, axis: .vertical)
                    .font(.refds(size: 15, scaledSize: 1.2 * 15, weight: .regular, style: .body))
            }
            
            Button {
                UIApplication.shared.endEditing()
                if !postBody.isEmpty {
                    Task { await addAnswer() }
                }
            } label: {
                CardBasicDetailView(title: "Responder", description: "", image: "checkmark.bubble.fill", imageColor: .green)
            }
        } header: {
            HStack {
                RefdsText("resposta", size: .small, color: .secondary)
                Spacer()
                Button(action: { isPreview.toggle() }, label: { RefdsTag(!isPreview ? "visualizar" : "escrever", color: !isPreview ? .green : .secondary) })
            }
        } footer: {
            if needLoadingAnswer { ProgressTabNewsView().padding(.top) }
        }
    }
    
    private func loadData() async {
        bodyContent = ""
        needLoading.toggle()
        viewModel = try? await presenter.showContentData()
        bodyContent = viewModel?.body?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) ?? ""
        needLoading.toggle()
    }
    
    private func addAnswer() async {
        if let parent_id = viewModel?.post_id {
            needLoadingAnswer.toggle()
            let answer = try? await makeAnswerPresenter().addAnswer(body: postBody, parent_id: parent_id)
            needLoadingAnswer.toggle()
            if answer != nil { needNavigationComments.toggle() }
        }
    }
    
    private func commentsView(commentsAmount: Int) -> some View {
        CardBasicDetailView(title: "Comentários", description: "\(commentsAmount > 0 ? "\(commentsAmount)" : "Não há comentários")", image: "ellipsis.message.fill", imageColor: .blue)
    }
    
    private func deletePost(slug: String) async {
        needLoading.toggle()
        let postDeleted = try? await makeDeletePostContentPresenter(user: loggedUsername, slug: slug).deletePostContent()
        needLoading.toggle()
        if postDeleted != nil { dismiss() }
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
