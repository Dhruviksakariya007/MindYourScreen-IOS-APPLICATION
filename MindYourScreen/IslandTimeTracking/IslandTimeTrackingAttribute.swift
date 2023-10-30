//
//  IslandTimeTrackingAttribute.swift
//  MindYourScreen
//
//  Created by Mac on 09/09/23.
//

import SwiftUI
import ActivityKit

struct IslandTimeTrackingAttribute: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var Time: Date = .now
    }
    var Sec: Int
    var Min: Int
    var Ho: Int
}

//struct DynamicTime: View {
////    let d = IslandTimeTrackingAttribute()
//    let timer = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
//    @State var Second: Int = 00
//    @State var Minute: Int = 00
//    @State var Hour: Int = 00
//    @State var to: CGFloat = 0
//
//    func tm() {
//        if Second == 0 {
//            to = CGFloat(Second+1) / 59
//            Second += 01
//            if Second == 60 {
//                Minute += 01
//                Second = 00
//            }
//            else if Minute == 60 {
//                Hour += 01
//                Minute = 00
//                Second = 00
//            }
//        }
//    }
//    var body: some View {
//        ZStack {
//            Circle()
//                .stroke(Color.gray.opacity(1), style: StrokeStyle(lineWidth: 5 ,lineCap: .round))
//                .frame(width: 200, height: 100)
//                .shadow(color: .white,radius: 4)
//
//            Circle()
//                .trim(from: 0,to: to)
//                .stroke(LinearGradient(gradient: Gradient(colors: [.black]), startPoint: .leading, endPoint: .trailing) , style: StrokeStyle(lineWidth: 5,lineCap: .round))
//                .frame(width: 200, height: 100)
//                .rotationEffect(.init(degrees: -90))
//                .shadow(color: .black.opacity(0.3), radius: 10)
//
//            VStack(spacing: 20) {
//                Text("\(Second)")
//                    .foregroundColor(.white)
//                    .font(.system(size: 35))
//                    .onReceive(timer) { _ in
//                        withAnimation(.default) {
//                            to = CGFloat(Second+1) / 59
//                            Second += 01
//                            if Second == 60 {
//                                Minute += 01
//                                Second = 00
//                            }
//                            else if Minute == 60 {
//                                Hour += 01
//                                Minute = 00
//                                Second = 00
//                            }
//                        }
//                    }
//            }
//        }
////        .onAppear(perform: tm)
//    }
//}
