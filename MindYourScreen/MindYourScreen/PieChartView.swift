//
//  PieChartView.swift
//  MindYourScreen
//
//  Created by Mac on 27/09/23.
//

import SwiftUI
import Charts

struct PieChartView: View {
    
    let data: [(Double, Color)] = [
        (2, .red),
        (3, .orange),
        (4, .yellow),
        (1, .green),
        (5, .blue),
        (4, .indigo),
        (2, .purple)
    ]
    
    var body: some View {
        Text("Hello")
    }
}

#Preview {
    PieChartView()
}
