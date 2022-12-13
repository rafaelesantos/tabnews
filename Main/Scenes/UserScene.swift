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
    @State private var needLoading: Bool = false
    @AppStorage("token") private var token: String = ""
    
    init(presenter: UserPresenterProtocol, username: String? = nil) {
        self._presenter = State(initialValue: presenter)
        self._username = State(initialValue: username)
    }
    
    var body: some View {
        if token.isEmpty {
            makeLoginScene()
        } else {
            VStack {
                if let user = user {
                    List {
                        if !needLoading {
                            Section("User Information") {
                                if let email = user.response.email, let notifications = user.response.notifications {
                                    CardBasicDetailView(title: "E-mail", description: email, image: "envelope.fill", imageColor: .blue.opacity(0.5))
                                    CardBasicDetailView(title: "Notification", description: notifications ? "Enable" : "Disable", image: "bell.fill", imageColor: .pink.opacity(0.5))
                                }
                                if let createdDate = user.response.created_at.replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "").asDate(withFormat: "yyyy-MM-dd HH:mm:ss.SSS") {
                                    CardBasicDetailView(title: "User Created On", description: createdDate.asString(withDateFormat: "dd MMMM, yyyy"), image: "calendar", imageColor: .orange.opacity(0.5))
                                }
                                
                                if let username = username, !username.isEmpty {
                                    HStack {
                                        NavigationLink {
                                            makeInitContentScene(user: username)
                                        } label: {
                                            CardBasicDetailView(title: "Show my posts", description: "", image: "sidebar.squares.left", imageColor: .teal.opacity(0.8))
                                        }
                                        
                                    }
                                }
                            }
                            
                            Section("TabMoney") {
                                HStack(spacing: 20) {
                                    HStack {
                                        Image(systemName: "dollarsign.square.fill")
                                            .foregroundColor(.blue.opacity(0.8))
                                        Text("Coins".uppercased())
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text("\(user.response.tabcoins)")
                                            .font(.footnote)
                                            .bold()
                                    }
                                    
                                    Text("|")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                    
                                    HStack {
                                        Text("\(user.response.tabcash)")
                                            .font(.footnote)
                                            .bold()
                                        Spacer()
                                        Text("Cash".uppercased())
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                        Image(systemName: "dollarsign.square.fill")
                                            .foregroundColor(.green.opacity(0.8))
                                    }
                                }
                            }
                            
                            Section(content: { }, header: {
                                VStack() {
                                    HStack {
                                        Text("Features")
                                        Spacer()
                                    }
                                    FlexibleView(data: user.response.features, spacing: 10, alignment: .leading) { feature in
                                        TagTabNewsView(feature.replacingOccurrences(of: ":", with: " ").replacingOccurrences(of: "_", with: " ").capitalized, color: .randomColor)
                                    }
                                }
                            })
                        }
                    }
                    .refreshable(action: {
                        needLoading.toggle()
                        Task {
                            self.user = try? await presenter.showUser(token: token)
                            if let username = self.user?.response.username {
                                self.username = username
                            }
                            needLoading.toggle()
                        }
                    })
                    .listStyle(.insetGrouped)
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if needLoading {
                                ProgressView()
                            }
                        }
                    })
                    .navigationTitle(user.response.username)
                }
                else { ProgressView() }
            }.task {
                user = try? await presenter.showUser(token: token)
                if let username = user?.response.username {
                    self.username = username
                }
            }
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
