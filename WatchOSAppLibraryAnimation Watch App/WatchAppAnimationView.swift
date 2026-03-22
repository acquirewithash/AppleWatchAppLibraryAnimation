//
//  WatchAppAnimationView.swift
//  WatchOSAppLibraryAnimation Watch App
//
//  Created by Ashutosh Pandey on 22/03/26.
//

import SwiftUI

struct WatchAppAnimationView: View {
    var totalAppCount: Int = 31

    var honeycombRows: [Int] {
        var rows: [Int] = []
        var remaining = totalAppCount
        var isThree = true
        while remaining > 0 {
            let capacity = isThree ? 3 : 4
            let count = min(remaining, capacity)
            rows.append(count)
            remaining -= count
            isThree.toggle()
        }
        return rows
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView([.vertical, .horizontal], showsIndicators: false) {
                    VStack(spacing: 1) {
                        ForEach(Array(honeycombRows.enumerated()), id: \.offset) { rowIndex, rowCount in
                            HStack(spacing: 8) {
                                ForEach(0..<rowCount, id: \.self) { colIndex in
                                    AppIconView(row: rowIndex, col: colIndex)
                                        .visualEffect { content, proxy in
                                            let frame = proxy.frame(in: .global)
                                            let containerFrame = geometry.frame(in: .global)
                                            
                                            let centerX = containerFrame.midX
                                            let centerY = containerFrame.midY
                                            
                                            let dx = frame.midX - centerX
                                            let dy = frame.midY - centerY
                                            
                                            let distance = sqrt(dx * dx + dy * dy)
                                            
                                            let maxDistance = containerFrame.width / 1.5 + 20
                                            let normalizedDistance = min(distance / maxDistance, 1.0)
                                            
                                            let curve = pow(normalizedDistance, 2.0)
                                            
                                            let scale = max(.zero, 1.0 - curve)
                                            let xOffset = -dx * (1 - scale) * 0.15
                                            let yOffset = -dy * (1 - scale) * 0.5
                                            return content
                                                .scaleEffect(scale)
                                                .offset(x: xOffset, y: yOffset)
                                        }
                                }
                            }
                        }
                    }
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 2.0
                    )
                }
                .defaultScrollAnchor(.center)
            }
        }
        .ignoresSafeArea()
    }
}

struct AppIconView: View {
    let row: Int
    let col: Int
    
    let colors: [Color] = [.red, .blue, .green, .orange, .purple, .yellow, .cyan, .mint, .pink]
    
    var body: some View {
        // Use row and col to pick a consistent color
        let colorIndex = (row * 7 + col * 3) % colors.count
        let color = colors[colorIndex]
        
        ZStack {
            if #available(watchOS 26.0, *) {
                Circle()
                    .fill(color.gradient)
                    .glassEffect(.regular)
            } else {
                Circle()
                    .fill(color.gradient)
            }
        }
        .frame(width: 44, height: 44) // Perfect size for 4-item width across screen
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    WatchAppAnimationView()
}
