//
//  AnalyticsScene.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import SwiftUI
import Presentation
import UserInterface

struct AnalyticsScene: View {
    @State private var presenter: AnalyticsPresenterProtocol
    @State private var analytics: AnalyticsViewModel?
    @State private var colors: [Color] = [.randomColor, .randomColor, .randomColor]
    
    init(presenter: AnalyticsPresenterProtocol) {
        self._presenter = State(initialValue: presenter)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if analytics == nil { ProgressTabNewsView() }
                else { analyticList }
            }
            .task { await loadData() }
            .navigationTitle("Analytics")
        }
    }
    
    private var analyticList: some View {
        List {
            if let usersCreated = analytics?.usersCreated, let max = usersCreated.max(by: { $0.cadastros < $1.cadastros }) {
                Section("Registration Analytics") {
                    HStack {
                        Text("Best Day")
                        Spacer()
                        Text("\(max.cadastros)")
                            .font(.footnote)
                            .bold()
                        TagTabNewsView("\(max.date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMMM") ?? "")", color: .green)
                    }
                    CardBarChartView(
                        title: "registrations",
                        color: colors[0],
                        marks: usersCreated.map({ (x: $0.date, y: NSNumber(integerLiteral: $0.cadastros)) }))
                    HStack {
                        Text("Total Registrations")
                        Spacer()
                        Text("\(usersCreated.map({ $0.cadastros }).reduce(0, +))")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.secondary)
                    }
                    
                    if usersCreated.count > 1 {
                        HStack {
                            Text("Period")
                            Spacer()
                            Text("\(usersCreated[0].date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMM") ?? "") - \(usersCreated[usersCreated.count - 1].date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMM") ?? "")")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.secondary)
                        }
                    }
                }.disabled(true)
            }
            
            if let status = analytics?.status {
                Section("Database") {
                    CardBasicDetailTagView(title: "Status", description: status.dependencies.database.status, color: .blue)
                    CardBasicDetailView(title: "Available Connections", description: "\(status.dependencies.database.max_connections)")
                    CardBasicDetailView(title: "Open Connections", description: "\(status.dependencies.database.opened_connections)")
                    HStack {
                        Text("Latency")
                        Spacer()
                        TagTabNewsView(String(format: "%.2lf ms", status.dependencies.database.latency.first_query), color: .blue)
                        TagTabNewsView(String(format: "%.2lf ms", status.dependencies.database.latency.second_query), color: .blue)
                        TagTabNewsView(String(format: "%.2lf ms", status.dependencies.database.latency.third_query), color: .blue)
                    }
                    CardBasicDetailView(title: "PostgreSQL Version", description: status.dependencies.database.version)
                }.disabled(true)
            }
            
            if let rootContentPublished = analytics?.rootContentPublished, let max = rootContentPublished.max(by: { $0.conteudos < $1.conteudos }) {
                Section("Publication Analytics") {
                    HStack {
                        Text("Best Day")
                        Spacer()
                        Text("\(max.conteudos)")
                            .font(.footnote)
                            .bold()
                        TagTabNewsView("\(max.date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMMM") ?? "")", color: .green)
                    }
                    CardBarChartView(
                        title: "publications",
                        color: colors[1],
                        marks: rootContentPublished.map({ (x: $0.date, y: NSNumber(integerLiteral: $0.conteudos)) }))
                    HStack {
                        Text("Total Publications")
                        Spacer()
                        Text("\(rootContentPublished.map({ $0.conteudos }).reduce(0, +))")
                            .bold()
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                    if rootContentPublished.count > 1 {
                        HStack {
                            Text("Period")
                            Spacer()
                            Text("\(rootContentPublished[0].date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMM") ?? "") - \(rootContentPublished[rootContentPublished.count - 1].date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMM") ?? "")")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.secondary)
                        }
                    }
                }.disabled(true)
            }
            
            if let status = analytics?.status {
                Section("Web Server") {
                    CardBasicDetailTagView(title: "Status", description: status.dependencies.webserver.status, color: .blue)
                    CardBasicDetailView(title: "Provider", description: status.dependencies.webserver.provider.capitalized)
                    CardBasicDetailView(title: "Environment", description: status.dependencies.webserver.environment.capitalized)
                    CardBasicDetailView(title: "Region on AWS", description: status.dependencies.webserver.aws_region)
                    CardBasicDetailView(title: "Region in Vercel", description: status.dependencies.webserver.vercel_region)
                    CardBasicDetailView(title: "Timezone", description: status.dependencies.webserver.timezone)
                    CardBasicDetailTagView(title: "Author of last commit", description: status.dependencies.webserver.last_commit_author)
                    CardBasicDetailView(title: "Commit SHA", description: status.dependencies.webserver.last_commit_message_sha)
                    CardBasicDetailView(title: "Node.js Version", description: status.dependencies.webserver.version)
                }.disabled(true)
            }
            
            if let childContentPublished = analytics?.childContentPublished, let max = childContentPublished.max(by: { $0.respostas < $1.respostas }) {
                Section("Comment Analytics") {
                    HStack {
                        Text("Best Day")
                        Spacer()
                        Text("\(max.respostas)")
                            .font(.footnote)
                            .bold()
                        TagTabNewsView("\(max.date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMMM") ?? "")", color: .green)
                    }
                    CardBarChartView(
                        title: "comments",
                        color: colors[2],
                        marks: childContentPublished.map({ (x: $0.date, y: NSNumber(integerLiteral: $0.respostas)) }))
                    HStack {
                        Text("Total Comments")
                        Spacer()
                        Text("\(childContentPublished.map({ $0.respostas }).reduce(0, +))")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.secondary)
                    }
                    
                    if childContentPublished.count > 1 {
                        HStack {
                            Text("Period")
                            Spacer()
                            Text("\(childContentPublished[0].date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMM") ?? "") - \(childContentPublished[childContentPublished.count - 1].date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMM") ?? "")")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.secondary)
                        }
                    }
                }.disabled(true)
            }
        }
        .listStyle(.insetGrouped)
        .refreshable { Task { await loadData() } }
    }
    
    private func loadData() async {
        analytics = nil
        colors = [.randomColor, .randomColor, .randomColor]
        analytics = try? await presenter.showAnalytics()
    }
}

struct AnalyticsScene_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsScene(presenter: makeAnalyticsPresenter())
    }
}
