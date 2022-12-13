//
//  ProgressTabNewsView.swift
//  TabNews
//
//  Created by Rafael Santos on 13/12/22.
//

import SwiftUI

public struct ProgressTabNewsView: View {
    public init() {}
    
    public var body: some View {
        LottieView(name: "Loading3")
            .frame(height: 60)
    }
}

struct ProgressTabNewsView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTabNewsView()
    }
}
