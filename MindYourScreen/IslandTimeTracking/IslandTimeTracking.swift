//
//  IslandTimeTracking.swift
//  IslandTimeTracking
//
//  Created by Mac on 09/09/23.
//




import WidgetKit
import SwiftUI
import Intents

struct IslandTimeTracking: Widget {
//    @State var islandattri = IslandTimeTrackingAttribute  (Sec: 0, Min: 0, Ho: 0)
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IslandTimeTrackingAttribute.self) { Context in
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.1) ,.blue.opacity(0.4)]), startPoint: .top, endPoint: .bottom))
                VStack(spacing: 10) {
                    HStack {
                        Text("Mind Your Screen Is Running...")
                            .font(.system(size: 15))
                        Spacer()

                    }
                }
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        TimeTrackingWidgetView(context: context)
//                            .font(.system(size: 25))
//                            .frame(alignment: .center)
//                        Text("dfddf")
                    }
                }
            } compactLeading: {
                
            } compactTrailing: {
                TimeTrackingWidgetView(context: context)
                    .frame(width: 40, alignment: .bottomLeading)
                    .font(.system(size: 20))
            } minimal: {
                Text("M")
            }

        }

    }
}

struct TimeTrackingWidgetView: View {
    let context: ActivityViewContext<IslandTimeTrackingAttribute>
    
    var body: some View {
        Text (context.state.Time, style: .relative)
    }
}

