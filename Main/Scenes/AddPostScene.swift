//
//  AddPostScene.swift
//  Main
//
//  Created by Rafael Santos on 19/12/22.
//

import SwiftUI
import RefdsUI
import Markdown
import Presentation
import UserInterface

struct AddPostScene: View {
    @State private var isPreview = false
    @State private var postTitle: String = ""
    @State private var postBody: String = ""
    @State private var postSource: String = ""
    @State private var presenter: AddPostContentPresenterProtocol
    @State private var needLoading = false
    @State private var needPresent = false
    @State private var viewModel: InitContentViewModel?
    private var username: String
    
    init(username: String) {
        self._presenter = State(initialValue: makeAddPostContentPresenter())
        self.username = username
    }
    
    var body: some View {
        VStack {
            Form {
                if isPreview {
                    Section { } footer: { MarkdownView(text: "#### " + postTitle + "\n\n" + postBody + "\n\n" + postSource, content: { ElementView(element: $0) }) }
                } else {
                    editPostTitleScene
                    editPostBodyScene
                    editPostSourceScene
                }
                
                Section { } footer: {
                    Button(action: {
                        UIApplication.shared.endEditing()
                        if !postTitle.isEmpty, !postBody.isEmpty {
                            needLoading.toggle()
                            Task {
                                viewModel = try? await presenter.addPostContent(title: postTitle, body: postBody, source: postSource)
                                if let slug = viewModel?.slug, !slug.isEmpty {
                                    needPresent.toggle()
                                }
                                needLoading.toggle()
                            }
                        }
                    }, label: {
                        RefdsText("PUBLICAR", size: .normal, color: (postTitle.isEmpty || postBody.isEmpty) ? .secondary : .green, weight: .bold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                    })
                    .background((postTitle.isEmpty || postBody.isEmpty) ? Color.secondary.opacity(0.2) : Color.green.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, -15)
                }
                
                Section { } footer: {
                    if needLoading { ProgressTabNewsView() }
                }
            }
        }
        .navigationTitle("Novo Conteúdo")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isPreview.toggle() }, label: { RefdsTag(!isPreview ? "visualizar" : "escrever", color: !isPreview ? .green : .secondary) })
            }
        }
        .navigationDestination(isPresented: $needPresent, destination: { makeInitContentScene(user: username) })
    }
    
    private var editPostTitleScene: some View {
        Section {
            TextField("Informe o título", text: $postTitle, axis: .vertical)
                .font(.refds(size: 15, scaledSize: 1.2 * 15, family: .moderatMono, weight: .bold, style: .body))
        } header: { RefdsText("título", size: .extraSmall, color: .secondary) }
    }
    
    private var editPostBodyScene: some View {
        Section { } header: { RefdsText("conteúdo", size: .extraSmall, color: .secondary) } footer: {
            TextEditor(text: $postBody)
                .onAppear {
                    postBody += "."
                    DispatchQueue.main.asyncAfter(deadline: .now()) { postBody.removeLast() }
                }
                .font(.refds(size: 17, scaledSize: 1.2 * 20, family: .moderatMono, weight: .regular, style: .body))
                .scrollContentBackground(.hidden)
                .background(.clear)
        }
    }
    
    private var editPostSourceScene: some View {
        Section {
            TextField("Informe a fonte (opcional)", text: $postSource, axis: .vertical)
                .font(.refds(size: 15, scaledSize: 1.2 * 15, family: .moderatMono, weight: .regular, style: .body))
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        } header: { RefdsText("fonte", size: .extraSmall, color: .secondary) }
    }
}

struct AddPostScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddPostScene(username: "rafaelesantos")
        }
    }
}
