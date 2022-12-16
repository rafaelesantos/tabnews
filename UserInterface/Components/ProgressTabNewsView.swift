//
//  ProgressTabNewsView.swift
//  TabNews
//
//  Created by Rafael Santos on 13/12/22.
//

import SwiftUI

public struct ProgressTabNewsView: View {
    private let style: ProgressTabNewsView.Style
    
    public init(style: ProgressTabNewsView.Style = .hourglass) {
        self.style = style
    }
    
    public var body: some View {
        LottieView(name: style.rawValue, loopMode: .loop)
            .frame(height: style.height)
    }
}

extension ProgressTabNewsView {
    public enum Style: String {
        case airplane = "LoadingAirPlane"
        case hourglass = "LoadingHourglass"
        
        var height: CGFloat {
            switch self {
            case .airplane: return 180
            case .hourglass: return 30
            }
        }
    }
}

struct ProgressTabNewsView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTabNewsView(style: .airplane)
    }
}
