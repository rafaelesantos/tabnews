//
//  SegmentedControlTabNews.swift
//  UserInterface
//
//  Created by Rafael Santos on 10/12/22.
//

import SwiftUI

struct SegmentedControlTabNews: View {
    private var segments: [String]
    private var selectedSegment: ((value: String, index: Int)) -> Void
    @State var currentSegment: (value: String, index: Int)
    
    init(segments: [String], selectedSegment: @escaping ((value: String, index: Int)) -> Void) throws {
        self.segments = segments
        self.selectedSegment = selectedSegment
        if let segment = segments.first, !segment.isEmpty, let index = segments.firstIndex(of: segment) {
            self.currentSegment = (value: segment, index: index)
        } else {
            throw NSError(domain: "segmentedControl.tabnews", code: 1)
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            HStack {
                ForEach(segments, id: \.self) { segment in
                    Button(action: {
                        if let index = segments.firstIndex(of: segment) {
                            selectedSegment((value: segment, index: index))
                            currentSegment = (value: segment, index: index)
                        }
                    }, label: {
                        Text(segment.uppercased())
                            .foregroundColor(currentSegment.value == segment ? Color.blue : .primary)
                            .padding(8)
                            .background(currentSegment.value == segment ? Color.blue.opacity(0.2) : .clear)
                            .cornerRadius(6)
                    })
                }
            }
            .padding(6)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(8)
        }
        .padding(.horizontal, 10)
    }
}

struct SegmentedControlTabNews_Previews: PreviewProvider {
    static var previews: some View {
        try? SegmentedControlTabNews(segments: ["relevant", "new"]) { _ in }
    }
}
