//
//  NotFoundTabNewsView.swift
//  UserInterface
//
//  Created by Rafael Santos on 15/12/22.
//

import SwiftUI

public struct NotFoundTabNewsView: View {
    private let style: NotFoundTabNewsView.Style
    
    public init(style: NotFoundTabNewsView.Style = .spaceship) {
        self.style = style
    }
    
    public var body: some View {
        LottieView(name: style.rawValue)
            .frame(height: style.height)
    }
}

extension NotFoundTabNewsView {
    public enum Style: String {
        case spaceship = "NotFoundSpaceship"
        case astronaut = "NotFoundAstrounaut"
        case floating = "NotFoundFloating"
        
        var height: CGFloat {
            switch self {
            case .spaceship: return 350
            case .astronaut: return 350
            case .floating: return 350
            }
        }
    }
}

struct NotFoundTabNewsView_Previews: PreviewProvider {
    static var previews: some View {
        NotFoundTabNewsView(style: .astronaut)
    }
}
