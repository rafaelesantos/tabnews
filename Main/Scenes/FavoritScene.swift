//
//  FavoritScene.swift
//  Main
//
//  Created by Rafael Santos on 22/12/22.
//

import SwiftUI
import RefdsUI
import Presentation
import UserInterface

struct FavoritScene: View {
    @AppStorage("favoritContents") var favoritContents = [InitContentViewModel]()
    @AppStorage("favoritUsers") var favoritUsers = [UserViewModel]()
    @State private var queryString: String = ""
    @State private var shareSheetItems: [Any] = []
    @State private var needNavigationShare = false
    
    var body: some View {
        List {
            if favoritUsers.count > 0 {
                Section { sectionUsers } header: {
                    RefdsText("Usuários", size: .extraSmall, color: .secondary)
                }
            }
            
            if favoritContents.count > 0 {
                Section { sectionPosts } header: {
                    RefdsText("Postagens", size: .extraSmall, color: .secondary)
                }
            }
            
            if favoritUsers.count == 0 && favoritContents.count == 0 {
                Section {} footer: {
                    NotFoundTabNewsView(style: .floating)
                }
            }
        }
        .navigationTitle("Favoritos")
        .searchable(text: $queryString, prompt: "Busque por conteúdo")
        .sheet(isPresented: $needNavigationShare, content: { ActivityViewController(activityItems: $shareSheetItems) })
    }
    
    private var sectionPosts: some View {
        ForEach(favoritContents.filter({ searchContents(content: $0) }).reversed(), id: \.id) { content in
            if let user = content.owner_username, let slug = content.slug {
                NavigationLink(destination: makeContentDataScene(user: user, slug: slug)) {
                    if let _ = content.body {
                        CardContentChildrenView(viewModel: content)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) { swipeDeleteButton(content: content) }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                if let username = content.owner_username, let slug = content.slug, let url = URL(string: "https://tabnews.com.br/\(username)/\(slug)") {
                                    swipeShareButton(url: url)
                                }
                            }
                    } else {
                        CardInitContentView(viewModel: content)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) { swipeDeleteButton(content: content) }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                if let username = content.owner_username, let slug = content.slug, let url = URL(string: "https://tabnews.com.br/\(username)/\(slug)") {
                                    swipeShareButton(url: url)
                                }
                            }
                    }
                }
            } else {
                CardInitContentView(viewModel: content)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) { swipeDeleteButton(content: content) }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        if let username = content.owner_username, let slug = content.slug, let url = URL(string: "https://tabnews.com.br/\(username)/\(slug)") {
                            swipeShareButton(url: url)
                        }
                    }
            }
        }
    }
    
    private var sectionUsers: some View {
        ForEach(favoritUsers.filter({ searchUsers(user: $0) }).reversed(), id: \.id) { user in
            NavigationLink {
                makeInitContentScene(user: user.response.username)
            } label: {
                HStack {
                    RefdsText(user.response.username)
                    Spacer()
                    HStack {
                        Image(systemName: "dollarsign.square.fill")
                            .resizable()
                            .scaledToFit()
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.blue)
                            .frame(width: 16, height: 16)
                        RefdsText("\(user.response.tabcoins)", size: .small)
                        Image(systemName: "dollarsign.square.fill")
                            .resizable()
                            .scaledToFit()
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.green)
                            .frame(width: 16, height: 16)
                        RefdsText("\(user.response.tabcash)", size: .small)
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) { swipeDeleteUserButton(user: user) }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    if let url = URL(string: "https://tabnews.com.br/\(user.response.username)") {
                        swipeShareButton(url: url)
                    }
                }
            }

        }
    }
    
    private func swipeDeleteButton(content: InitContentViewModel) -> some View {
        Button {
            if let index = favoritContents.firstIndex(where: { $0.post_id == content.post_id }) {
                favoritContents.remove(at: index)
            }
        } label: {
            Image(systemName: "trash.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
        .tint(.pink)
    }
    
    private func swipeDeleteUserButton(user: UserViewModel) -> some View {
        Button {
            if let index = favoritUsers.firstIndex(where: { $0.response.id == user.response.id }) {
                favoritUsers.remove(at: index)
            }
        } label: {
            Image(systemName: "trash.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
        .tint(.pink)
    }
    
    private func swipeShareButton(url: URL) -> some View {
        Button {
            shareSheetItems = [url]
            needNavigationShare.toggle()
        } label: {
            Image(systemName: "square.and.arrow.up")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
        .tint(.orange)
    }
    
    private func searchContents(content: InitContentViewModel) -> Bool {
        let queryString = queryString.lowercased()
        if queryString.isEmpty { return true }
        let username = content.owner_username?.lowercased().contains(queryString) ?? false
        let title = content.title?.lowercased().contains(queryString) ?? false
        let body = content.body?.lowercased().contains(queryString) ?? false
        return username || title || body
    }
    
    private func searchUsers(user: UserViewModel) -> Bool {
        let queryString = queryString.lowercased()
        if queryString.isEmpty { return true }
        let username = user.response.username.contains(queryString)
        let email = user.response.email?.contains(queryString) ?? false
        return username || email
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    @Binding var activityItems: [Any]
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: nil)

        controller.excludedActivityTypes = excludedActivityTypes

        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

struct FavoritScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoritScene()
        }
    }
}
