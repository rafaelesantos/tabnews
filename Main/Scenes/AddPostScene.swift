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
                editPostTitleScene
                editPostBodyScene
                editPostSourceScene
                
                Section { } footer: {
                    if needLoading { ProgressTabNewsView() }
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
        .navigationTitle("Novo Conteúdo")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
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
                    RefdsTag("PUBLICAR", color: (postTitle.isEmpty || postBody.isEmpty) ? .secondary : .green)
                })
            }
        })
        .navigationDestination(isPresented: $needPresent, destination: { makeInitContentScene(user: username) })
    }
    
    private var editPostTitleScene: some View {
        Section {
            TextField("Informe o título", text: $postTitle, axis: .vertical)
                .font(.refds(size: 15, scaledSize: 1.2 * 15, weight: .bold, style: .body))
        } header: { RefdsText("título", size: .extraSmall, color: .secondary) }
    }
    
    private var editPostBodyScene: some View {
        Section {
            if isPreview {
                MarkdownView(text: postBody, content: { ElementView(element: $0) })
            } else {
                TextField("Informe o conteúdo da postagem", text: $postBody, axis: .vertical)
                    .font(.refds(size: 15, scaledSize: 1.2 * 15, weight: .regular, style: .body))
            }
        } header: {
            HStack {
                RefdsText("conteúdo", size: .extraSmall, color: .secondary)
                Spacer()
                Button(action: { isPreview.toggle() }, label: { RefdsTag(!isPreview ? "visualizar" : "escrever", color: !isPreview ? .green : .secondary) })
            }
            
        }
    }
    
    private var editPostSourceScene: some View {
        Section {
            TextField("Informe a fonte (opcional)", text: $postSource, axis: .vertical)
                .font(.refds(size: 15, scaledSize: 1.2 * 15, weight: .regular, style: .body))
                .textContentType(.URL)
                .keyboardType(.URL)
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
