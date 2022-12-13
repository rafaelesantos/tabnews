//
//  ApplicationExtension.swift
//  Main
//
//  Created by Rafael Santos on 13/12/22.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
