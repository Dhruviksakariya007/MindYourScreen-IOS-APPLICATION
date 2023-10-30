//
//  ContentView.swift
//  MindYourScreen
//
//  Created by Mac on 29/08/23.
//

import SwiftUI

struct ContentView: View {
    @State var Dark: Bool = false
    let timer = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    @State var Second: Int = 00
    @State var Minute: Int = 00
    @State var Hour: Int = 00
    @State var to: CGFloat = 0
    
    func requestNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { _, _ in
            print("Notification is Allowed")
        }
    }
    func Notify(){
        let Content = UNMutableNotificationContent()
        Content.title = "Message"
        Content.body = "Time to break a sweat! Your phone can wait, but your fitness can't."

        let Trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let Request = UNNotificationRequest(identifier: "MSG", content: Content, trigger: Trigger)

        UNUserNotificationCenter.current().add(Request, withCompletionHandler: nil)
        print("Time to break a sweat! Your phone can wait, but your fitness can't.")

    }
    
    
    var body: some View {
        VStack {
            withAnimation {
                NavigationStack {
                    VStack() {
                        HStack {
                            Text("Mind Your Screen")
                                .bold()
                                .font(.system(size: 25))
                                .foregroundColor(Dark ? .white : .black)
                        
                            Spacer()
                            
                            Button {
                                Dark.toggle()
                            } label: {
                                Image(systemName: Dark ? "sun.min.fill" : "moon.stars.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(Dark ? .white : .black)
                            }
                        }
                        .frame(height: 40)
                        .padding()
                        .background(Color(.systemGray5))
                        
                        
                        
                        
                        ZStack {
//                            LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .trailing, endPoint: .leading).ignoresSafeArea()
                            ScrollView {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.black.opacity(0.2), style: StrokeStyle(lineWidth: 3 ,lineCap: .round))
                                            .frame(width: 120, height: 120)
                                        
                                        
                                        Circle()
                                            .trim(from: 0,to: self.to)
                                            .stroke(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing) , style: StrokeStyle(lineWidth: 3,lineCap: .round))
                                            .frame(width: 120, height: 120)
                                            .rotationEffect(.init(degrees: -90))
                                            .shadow(color: .black.opacity(0.3), radius: 10)
                                        
                                        Text("\(Second)")
                                            .foregroundColor(.black)
                                            .font(.system(size: 40))
                                            .cornerRadius(20)
                                            .onAppear(perform: requestNotification)
                                            .onReceive(timer) { _ in
                                                withAnimation(.default) {
                                                    self.to = CGFloat(Second+1) / 59
                                                    self.Second += 01
                                                    if self.Second == 60 {
                                                        Minute += 01
                                                        Second = 00
                                                    }
                                                    else if Minute == 60 {
                                                        Hour += 01
                                                        Minute = 00
                                                        Second = 00
                                                    }
                                                    else if Second == 59 {
                                                        self.Notify()
                                                    }
                                                }
                                            } 
                                    }
                                    .frame(width: 150, height: 150)
                                    .background(LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom))
                                    .cornerRadius(100)
                                    .shadow(radius: 5)
                                    
                                    
                                    Spacer()
                                    
                                        Text("\(Hour) : \(Minute) : \(Second)")
                                            .foregroundColor(Dark ? .white : .black)
                                            .font(.system(size:40))
                                            .cornerRadius(20)
                                            .frame(width: 200,height: 150)
                                            .background(LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom))

                                            .cornerRadius(20)
                                            .shadow(color: .black.opacity(0.5),radius: 5)
                                    
                                }
//                                .background(LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom))
                                .frame(width: 370, height: 250)
//                                .background(Color(.red))
                                

                                .padding()
                                Spacer()
                                BovChartView()
                                    .padding()
                            }
                        }
                    }
                    .background(Color(Dark ? .black : .white))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .ignoresSafeArea()    }
}
