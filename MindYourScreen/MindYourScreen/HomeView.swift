//
//  HomeView.swift
//  MindYourScreen
//
//  Created by Mac on 02/09/23.
//

import SwiftUI
import ActivityKit
import DeviceActivity
import CoreMotion

//class PickupCounter: ObservableObject {
//    @Published var totalPickups = 0
//}

struct HomeView: View {
    @State var pickupCounter = 0
    let motionManager = CMMotionManager()
    
    func startMotionTracking() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, error in
                if let acceleration = accelerometerData?.acceleration {
                    let totalAcceleration = abs(acceleration.x) + abs(acceleration.y) + abs(acceleration.z)
                    if totalAcceleration > 3.0 { // Adjust this threshold as needed
                        self.pickupCounter += 1
                    }
                }
            }
        }
    }
    
    let timer = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    @State var Second: Int = UserDefaults.standard.integer(forKey: "SECOND_KEY") ?? 00
    @State var Minute: Int = UserDefaults.standard.integer(forKey: "MINUTE_KEY") ?? 00
    @State var Hour: Int = UserDefaults.standard.integer(forKey: "HOUR_KEY") ?? 00
    @State var Hourr: Int = 00
    @State var to: CGFloat = 0
    @State var SelectedTab = "Home"
    @State var Dark: Bool = false
    @State var StarRatting: Int = 5
    @State var liveActivityId = ""
    @State var showSignInView: Bool = false
//    let dayy = Calendar.current.dateComponents([.weekday], from: .now).weekday
//    let date = Calendar.current.dateComponents([.day], from: .now).day
//    @State var currentDay: String = ""
//    @State var currentDate: Int = 0
    
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
    func addLiveActivity() {
        let Attribute = IslandTimeTrackingAttribute(Sec: Second, Min: Minute, Ho: Hour)
        let InitialContentState = IslandTimeTrackingAttribute.ContentState(Time: .now)
        
        do {
            let activity = try Activity<IslandTimeTrackingAttribute>.request(attributes: Attribute, contentState: InitialContentState, pushType: nil)
            liveActivityId = activity.id

            print("Live Activity Added Successfully, id: \(activity.id)")

        } catch {
            print("Error In Live Activity")
        }

    }
    func removeLiveActivity() {
        if let activity = Activity.activities.first(where: { ( activity: Activity<IslandTimeTrackingAttribute> ) in activity.id == liveActivityId
            
        }) {
            Task {
                await activity.end(using: IslandTimeTrackingAttribute.ContentState(Time: .now) , dismissalPolicy: .immediate)
            }
        }
        storeKey()
    }
    func time() {
        self.to = CGFloat(Second+1) / 59
        self.Second += 01
        if self.Second == 60 {
            Minute += 01
            Second = 00
            Hourr += 01
        }
        else if Minute == 60 {
            Hour += 01
            
            Minute = 00
            Second = 00
            StarRatting -= 1
        }   
        else if Second == 59 {
            self.Notify()
        }
    }
    func storeKey() {
        UserDefaults.standard.set(Second, forKey: "SECOND_KEY") 
        UserDefaults.standard.set(Minute, forKey: "MINUTE_KEY") 
        UserDefaults.standard.set(Hour, forKey: "HOUR_KEY") 
    }
    
    var body: some View {
        if showSignInView == true {
            NotSignInView()
                .fullScreenCover(isPresented: $showSignInView) {
                    NavigationStack {
                        AuthenticationView(showSignInView: $showSignInView)
                    }
                }
        }
        else {
            VStack {
                Header(title: "Mind Your Screen")
                    
                ScrollView {
                    VStack(spacing: 30) {
                        Text("")
                            .font (
                                Font.custom("Inter", size: 25)
                                    .weight(.medium)
                            )
                            .foregroundColor(.black)
                            .frame(width: 301, alignment: .topTrailing)
                        
    //            Screen Time Circle
                        ZStack(alignment: .center) {
                            Circle()
                                .stroke(Color.gray.opacity(1), style: StrokeStyle(lineWidth: 13 ,lineCap: .round))
                                .frame(width: 200, height: 200)
                                .shadow(color: .blue.opacity(0.80),radius: 4)
                            
                            
                            Circle()
                                .trim(from: 0,to: self.to)
                                .stroke(LinearGradient(gradient: Gradient(colors: [.black]), startPoint: .leading, endPoint: .trailing) , style: StrokeStyle(lineWidth: 13,lineCap: .round))
                                .frame(width: 200, height: 200)
                                .rotationEffect(.init(degrees: -90))
                                .shadow(color: .black.opacity(0.3), radius: 10)
                            
                            // Second/
                            VStack(spacing: 20) {
                                Text("\(Second)")
                                    .foregroundColor(.black)
                                    .font(.system(size: 35))
                                    .onAppear(perform: requestNotification)
                                    .onReceive(timer) { _ in
                                        withAnimation(.default) {
                                            time()
                                        }
                                    }
                                Text("\(Minute)m")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 30))
                                
                            }
                            
                        }
                        
                        
    //                    Star Ratting
                            Rectangle()
                                .fill(.brown.opacity(0.3))
                                .frame(width: .infinity, height: 100)
                                .cornerRadius(10)
                                .overlay {
                                    VStack(spacing: 10) {
                                        Text("Wow! You are doing great..! 😍")
                                            .font(
                                                Font.custom("Inter", size: 24)
                                                    .weight(.medium)
                                            )
                                            .foregroundColor(.black)
                                        HStack {
                                            Image(systemName: StarRatting >= 1 ? "star.fill" : "star")
                                            Image(systemName: StarRatting >= 2 ? "star.fill" : "star")
                                            Image(systemName: StarRatting >= 3 ? "star.fill" : "star")
                                            Image(systemName: StarRatting >= 4 ? "star.fill" : "star")
                                            Image(systemName: StarRatting == 5 ? "star.fill" : "star")
                                        }
                                        .font(.system(size: 25))
                                    }
    //                                .shadow(color: .black, radius: 10)
                                }
                        
                        VStack(spacing: 25) {
                            HStack(spacing: 30) {
                                Button {
    //                        print(date)
    //                        getDay()
                                } label: {
                                    Text(Date.now, style: .date)
                                        .accentColor(.black)
                                        .font(.system(size: 20))
                                        .frame(width: 150, height: 100)
                                        .background(.blue.opacity(0.2))
                                        .cornerRadius(20)
                                }
                                
                                Button(action: {
//                                    startMotionTracking()
                                }) {
//                                    Text("Total Pickups: \(pickupCounter.totalPickups)")
//                                                    .font(.largeTitle)
//                                                    .padding()
                                    Text("Total Pickups")
                                        .frame(width: 150, height: 100)
                                        .background(.blue.opacity(0.2))
                                        .cornerRadius(20)
                                }
                            }
                            
                            HStack(spacing: 30) {
                                Text("Blocked App")
                                    .frame(width: 150, height: 100)
                                    .background(.blue.opacity(0.2))
                                    .cornerRadius(20)
                                
                                Text("\(Hour) Hours")
                                    .frame(width: 150, height: 100)
                                    .font(.system(size: 20))
                                    .background(.blue.opacity(0.2))
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.top)
                        .onDisappear {
                            removeLiveActivity()
                        }
                    }
                }
            }
            .onAppear {
                addLiveActivity()
                let authUse = try? AuthenticationManager.shared.getAuthenticatedUser()
                showSignInView = authUse == nil ? true : false
            }
    //        .fullScreenCover(isPresented: $showSignInView) {
    //            NavigationStack {
    //                AuthenticationView(showSignInView: $showSignInView )
    //            }
    //        }
            .padding()
        }
    }
        }
        

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct Header: View {
    @State var title: String
    
    var body: some View {
            NavigationStack{
                HStack {
                    NavigationLink {
                        Text("Nothing Hear")
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .font(
                                Font.custom("Inter", size: 30)
                                    .weight(.medium)
                            )
                            .foregroundColor(.black)
                    }

                    
                    Spacer()
                    Text(title)
                        .font(
                            Font.custom("Inter", size: 23)
                                .weight(.medium)
                        )
                    Spacer()
                    NavigationLink {
                        Account()
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(
                                Font.custom("Inter", size: 30)
                                    .weight(.medium)
                            )
                            .accentColor(.black)
                    }

                }
            }
        
    }
}
