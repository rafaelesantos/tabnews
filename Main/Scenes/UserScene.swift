//
//  UserScene.swift
//  Main
//
//  Created by Rafael Santos on 12/12/22.
//

import SwiftUI
import Presentation
import UserInterface

struct UserScene: View {
    @State private var presenter: UserPresenterProtocol
    @State private var user: UserViewModel?
    @State private var username: String?
    
    @AppStorage("token") var token: String = ""
    @AppStorage("coin") var coin: String = ""
    @AppStorage("cash") var cash: String = ""
    
    init(presenter: UserPresenterProtocol, username: String? = nil) {
        self._presenter = State(initialValue: presenter)
        self._username = State(initialValue: username)
    }
    
    var body: some View {
        if token.isEmpty { makeLoginScene().navigationTitle("") }
        else { userScene }
    }
    
    private var userScene: some View {
        VStack {
            List {
                if user == nil { sectionLoading }
                else {
                    sectionUserInformation
                    sectionTabMoney
                    sectionPermissions
                    if user?.response.email is String { sectionLogout }
                }
            }
            .refreshable { Task { await loadData() } }
            .listStyle(.insetGrouped)
        }
        .task { await loadData() }
        .navigationTitle(token.isEmpty ? "" : username ?? "Usuário")
    }
    
    private var sectionUserInformation: some View {
        Section("informações do usuário") {
            if let email = user?.response.email, let notifications = user?.response.notifications {
                CardBasicDetailView(title: "E-mail", description: email, image: "square.text.square.fill", imageColor: .blue)
                CardBasicDetailView(title: "Notificação", description: notifications ? "Ativo" : "Inativo", image: "bell.square.fill", imageColor: .pink)
            }
            if let createdDate = user?.response.created_at.replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "").asDate(withFormat: "yyyy-MM-dd HH:mm:ss.SSS") {
                CardBasicDetailView(title: "Data de criação", description: createdDate.asString(withDateFormat: "dd MMMM, yyyy"), image: "calendar.badge.clock", imageColor: .orange)
            }
            
            if let username = username, !username.isEmpty {
                HStack {
                    NavigationLink { makeInitContentScene(user: username) } label: {
                        CardBasicDetailView(title: "Publicações", description: "", image: "rectangle.stack.badge.person.crop.fill", imageColor: .teal)
                    }
                }
            }
        }
    }
    
    private var sectionPermissions: some View {
        Section(content: { }, header: {
            if let features = user?.response.features {
                VStack() {
                    HStack {
                        Text("Permissões")
                        Spacer()
                    }
                    FlexibleView(data: features, spacing: 10, alignment: .leading) { feature in
                        TagTabNewsView(feature.replacingOccurrences(of: ":", with: " ").replacingOccurrences(of: "_", with: " ").capitalized, color: .randomColor)
                    }
                }
            }
        })
    }
    
    private var sectionTabMoney: some View {
        Section("TabMoney") {
            if let tabcoins = user?.response.tabcoins, let tabcash = user?.response.tabcash {
                CardBasicDetailView(title: "Tab coins", description: "\(tabcoins)", image: "dollarsign.square.fill", imageColor: .blue)
                CardBasicDetailView(title: "Tab cash", description: "\(tabcash)", image: "dollarsign.square.fill", imageColor: .green)
            }
        }
    }
    
    private var sectionLogout: some View {
        Section {
            Button {
                logout()
            } label: {
                CardBasicDetailView(title: "Sair da contar", description: "", image: "lock.shield.fill", imageColor: .red)
            }
            .foregroundColor(.primary)
        }
    }
    
    private var sectionLoading: some View {
        Section(content: {}, header: { ProgressTabNewsView() })
            .frame(height: 350)
    }
    
    private func logout() {
        token = ""
        coin = ""
        cash = ""
        user = nil
    }
    
    private func loadData() async {
        user = nil
        user = try? await presenter.showUser(token: token)
        if let user = user, user.response.email?.isEmpty == false {
            if username == nil { username = user.response.username }
            coin = "\(user.response.tabcoins)"
            cash = "\(user.response.tabcash)"
        }
    }
}

struct UserScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserScene(presenter: makeUserPresenter())
        }
    }
}
