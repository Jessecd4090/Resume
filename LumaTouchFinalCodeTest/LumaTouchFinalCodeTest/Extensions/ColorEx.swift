//
//  ColorEx.swift
//  LumaTouchFinalCodeTest
//
//  Created by Jestin Dorius on 7/28/25.
//

import SwiftUI

extension Color {
    init?(name: String) {
        switch name {
        case "red": self = .red
        case "green": self = .green
        case "gray": self = .gray
        case "orange": self = .orange
        case "cyan": self = .cyan
        case "yellow": self = .yellow
        case "mint": self = .mint
                // Add other cases as needed
        default: return nil
        }
    }
}
