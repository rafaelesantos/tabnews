//
//  AnalyticsScene.swift
//  Main
//
//  Created by Rafael Santos on 11/12/22.
//

import SwiftUI
import RefdsUI
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
        VStack {
            analyticList
        }
        .task { await loadData() }
        .navigationTitle("Estatísticas e Status")
    }
    
    private var analyticList: some View {
        List {
            if analytics == nil { sectionLoading }
            else {
                if let usersCreated = analytics?.usersCreated, let max = usersCreated.max(by: { $0.cadastros < $1.cadastros }) {
                    Section("Estatística de registros") {
                        HStack {
                            RefdsText("Melhor dia")
                            Spacer()
                            RefdsText("\(max.cadastros)", size: .small, weight: .bold)
                            RefdsTag("\(max.date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMMM") ?? "")", color: .green)
                        }
                        CardBarChartView(
                            title: "registros",
                            color: colors[0],
                            marks: usersCreated.map({ (x: $0.date, y: NSNumber(integerLiteral: $0.cadastros)) }))
                        CardBasicDetailView(title: "Total de registros", description: "\(usersCreated.map({ $0.cadastros }).reduce(0, +))")
                        
                        if usersCreated.count > 1 {
                            CardBasicDetailView(title: "Período", description: "\(usersCreated[0].date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMM") ?? "") - \(usersCreated[usersCreated.count - 1].date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMM") ?? "")")
                        }
                    }.disabled(true)
                }
                
                if let status = analytics?.status {
                    Section("Banco de Dados") {
                        CardBasicDetailTagView(title: "Status", description: status.dependencies.database.status, color: .blue)
                        CardBasicDetailView(title: "Conexões disponíveis", description: "\(status.dependencies.database.max_connections)")
                        CardBasicDetailView(title: "Conexões abertas", description: "\(status.dependencies.database.opened_connections)")
                        HStack {
                            Text("Latência")
                            Spacer()
                            RefdsTag(String(format: "%.2lf ms", status.dependencies.database.latency.first_query), color: .blue)
                            RefdsTag(String(format: "%.2lf ms", status.dependencies.database.latency.second_query), color: .blue)
                            RefdsTag(String(format: "%.2lf ms", status.dependencies.database.latency.third_query), color: .blue)
                        }
                        CardBasicDetailView(title: "Versão PostgreSQL", description: status.dependencies.database.version)
                    }.disabled(true)
                }
                
                if let rootContentPublished = analytics?.rootContentPublished, let max = rootContentPublished.max(by: { $0.conteudos < $1.conteudos }) {
                    Section("Estatística das publicações") {
                        HStack {
                            RefdsText("Melhor dia")
                            Spacer()
                            RefdsText("\(max.conteudos)", size: .small, weight: .bold)
                            RefdsTag("\(max.date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMMM") ?? "")", color: .green)
                        }
                        CardBarChartView(
                            title: "publicações",
                            color: colors[1],
                            marks: rootContentPublished.map({ (x: $0.date, y: NSNumber(integerLiteral: $0.conteudos)) }))
                        CardBasicDetailView(title: "Total de conteúdos", description: "\(rootContentPublished.map({ $0.conteudos }).reduce(0, +))")
                        
                        if rootContentPublished.count > 1 {
                            CardBasicDetailView(title: "Período", description: "\(rootContentPublished[0].date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMM") ?? "") - \(rootContentPublished[rootContentPublished.count - 1].date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMM") ?? "")")
                        }
                    }.disabled(true)
                }
                
                if let status = analytics?.status {
                    Section("Servidor") {
                        CardBasicDetailTagView(title: "Status", description: status.dependencies.webserver.status, color: .blue)
                        CardBasicDetailView(title: "Provedor", description: status.dependencies.webserver.provider.capitalized)
                        CardBasicDetailView(title: "Ambiente", description: status.dependencies.webserver.environment.capitalized)
                        CardBasicDetailView(title: "Região na AWS", description: status.dependencies.webserver.aws_region)
                        CardBasicDetailView(title: "Região na Vercel", description: status.dependencies.webserver.vercel_region)
                        CardBasicDetailView(title: "Timezone", description: status.dependencies.webserver.timezone)
                        CardBasicDetailTagView(title: "Autor do último commit", description: status.dependencies.webserver.last_commit_author)
                        CardBasicDetailView(title: "Commit SHA", description: status.dependencies.webserver.last_commit_message_sha)
                        CardBasicDetailView(title: "Versão do Node.js", description: status.dependencies.webserver.version)
                    }.disabled(true)
                }
                
                if let childContentPublished = analytics?.childContentPublished, let max = childContentPublished.max(by: { $0.respostas < $1.respostas }) {
                    Section("Estatística de comentários") {
                        HStack {
                            RefdsText("Melhor dia")
                            Spacer()
                            RefdsText("\(max.respostas)", size: .small, weight: .bold)
                            RefdsTag("\(max.date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMMM") ?? "")", color: .green)
                        }
                        CardBarChartView(
                            title: "comentários",
                            color: colors[2],
                            marks: childContentPublished.map({ (x: $0.date, y: NSNumber(integerLiteral: $0.respostas)) }))
                        CardBasicDetailView(title: "Total de respostas", description: "\(childContentPublished.map({ $0.respostas }).reduce(0, +))")
                        
                        if childContentPublished.count > 1 {
                            CardBasicDetailView(title: "Período", description: "\(childContentPublished[0].date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMM") ?? "") - \(childContentPublished[childContentPublished.count - 1].date.asDate(withFormat: "dd/MM")?.asString(withDateFormat: "dd MMM") ?? "")")
                        }
                    }.disabled(true)
                }
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
    
    private var sectionLoading: some View {
        Section(content: {}, header: { ProgressTabNewsView() })
            .frame(height: 350)
    }
}

struct AnalyticsScene_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsScene(presenter: makeAnalyticsPresenter())
    }
}
