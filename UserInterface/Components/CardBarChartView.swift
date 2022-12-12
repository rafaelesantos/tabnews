//
//  CardBarChartView.swift
//  UserInterface
//
//  Created by Rafael Santos on 11/12/22.
//

import SwiftUI
import Charts

public struct CardBarChartView: View {
    private var title: String
    private var color: Color
    private var marks: [(id: UUID, x: String, y: NSNumber)]
    
    public init(title: String, color: Color = .randomColor, marks: [(x: String, y: NSNumber)]) {
        self.title = title
        self.color = color
        let count = marks.count
        if count > 6 {
            self.marks = Array(marks.map({ (id: UUID(), x: $0.x, y: $0.y) })[(count - 7)...(count - 1)])
        } else {
            self.marks = marks.map({ (id: UUID(), x: $0.x, y: $0.y) })
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(title.capitalized)
                    .font(.body)
                    .bold()
                Spacer()
                TagTabNewsView("\(marks.map({ $0.y.intValue }).reduce(0, +)) last week", color: color)
            }
            Chart {
                ForEach(marks, id: \.id) { mark in
                    BarMark(x: .value("Date", mark.x), y: .value(title, mark.y.intValue))
                }
            }
            .foregroundColor(color)
            .frame(height: 150)
        }
        .background(Color.clear)
    }
}

struct CardBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        CardBarChartView(title: "any-title", marks: [
            (x: "01/12", y: 5),
            (x: "02/12", y: 1),
            (x: "03/12", y: 8),
            (x: "04/12", y: 3),
            (x: "05/12", y: 7),
            (x: "06/12", y: 2),
            (x: "07/12", y: 4),
            (x: "08/12", y: 9)
        ])
    }
}
