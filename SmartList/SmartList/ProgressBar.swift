//
//  ProgressBar.swift
//  SmartList
//
//  Created by Gio Lavilla on 2025-03-12.
//

import SwiftUI

struct ProgressBar: View {
    var value: Double // The progress percentage (0.0 - 1.0)

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 8)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width), height: 8)
                    .foregroundColor(value >= 1.0 ? .red : .green) // Red if over budget, green otherwise
                    .animation(.linear, value: value)
            }
            .cornerRadius(4)
        }
        .frame(height: 8)
    }
}


