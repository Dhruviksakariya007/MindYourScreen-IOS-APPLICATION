//
//  BovChart.swift
//  MindYourScreen
//
//  Created by Mac on 29/08/23.
//

import SwiftUI
import Charts
import FirebaseFirestore
import FirebaseCore
import Firebase


struct DBuser {
    let userId: String
    let email: String
    let sun: Int
    let mon: Int
    let tue: Int
    let wed: Int
    let thu: Int
    let fri: Int
    let sat: Int
}
@MainActor
final class BovChartViewModel: ObservableObject {
    
    @Published private(set) var user: DBuser? = nil
    
    func loadCurrentUse() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await userManager.shared.getData(userId: authDataResult.uid)
    }
}

struct bcharts: Identifiable {
    var id: String
    var sun: String
    var mon: String
    var tue: String
    var wed: String
    var thu: String
    var fri: String
    var sat: String
    
}

class userManager: ObservableObject {
    @Published var list = [bcharts]()
    static let shared = userManager()
//    private init() { }
    
    func createNewUser (auth: AuthDataResultModel) {
        let userData: [String:Any] = [
            "user_id" : auth.uid,
            "email" : auth.email,
            "Date" : Timestamp(),
            "Sun" : 0,
            "Mon" : 0,
            "Tue" : 0,
            "Wed" : 0,
            "Thu" : 0,
            "Fri" : 0,
            "Sat" : 0
            ]
        
        Firestore.firestore().collection("bchart").document(auth.uid).setData(userData, merge: false)
    }
    
    func addData(auth: AuthDataResultModel) {
        
    }
    
    func Store(Collection: String, Key: String, Value: Any) {
        let db = Firestore.firestore().collection(Collection).addDocument(data: [Key : Value])
    }
    
    func getData(userId: String) async throws -> DBuser {
        let snapshot = try await Firestore.firestore().collection("bchart").document(userId).getDocument()
        guard let data = snapshot.data(),
              let userId = data["user_id"] as? String,
                let sun = data["Sun"] as? Int,
                let mon = data["Mon"] as? Int,
                let tue = data["Tue"] as? Int,
                let wed = data["Wed"] as? Int,
                let thu = data["Thu"] as? Int,
                let fri = data["Fri"] as? Int,
                let sat = data["Sat"] as? Int,
              let email = data["email"] as? String
        else {
            throw URLError(.badServerResponse)
        }
        
        let date = data["Date"] as? Date
        
//        return DBuser(userId: userId, sun: sun, mon: mon, tue: tue, wed: wed, thu: thu, fri: fri, sat: sat)
        return DBuser(userId: userId, email: email, sun: sun, mon: mon, tue: tue, wed: wed, thu: thu, fri: fri, sat: sat)
    }
    
    func updateData(bchartUpdate: bcharts, key: String, value: Int) {
        Firestore.firestore().collection("bchart").document(bchartUpdate.id).setData([ key : "\(value)"], merge: true) { error in
            if error == nil {
                
            }
        }
    }
    
}

struct BovChartView	: View {
//    let cdata = ForChartData()
//    let data = ForChartData().ChartData
    let timer = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    @State var Second: Int = UserDefaults.standard.integer(forKey: "CHART_SECOND") ?? 00
    @State var Minute: Int = UserDefaults.standard.integer(forKey: "CHART_MINUTE") ?? 00
    @State var Hour: Int = UserDefaults.standard.integer(forKey: "CHART_HOUR") ?? 00
    @ObservedObject var model = userManager()
    @StateObject var viewmodel = BovChartViewModel()

    @State var day: String = UserDefaults.standard.string(forKey: "CHART_DAY") ?? ""

    func storeKey() {
        UserDefaults.standard.set(Second, forKey: "CHART_SECOND")
        UserDefaults.standard.set(Minute, forKey: "CHART_MINUTE")
        UserDefaults.standard.set(Hour, forKey: "CHART_HOUR")
        UserDefaults.standard.set(day, forKey: "CHART_DAY")
    }
    func time(){
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
    }
    func resetTime() {
        Second = 0
        Minute = 0
        Hour = 0
    }
    
    @State var su = 0
    @State var m = 0
    @State var tu = 0
    @State var w = 0
    @State var th = 0
    @State var f = 0
    @State var sa = 0
    
    @State var ScreenTimeData = [
        ScreenData(Day: "Sun", Hour: 0, Clr: .gray),
        ScreenData(Day: "Mon", Hour: 0, Clr: .gray),
        ScreenData(Day: "Tue", Hour: 0, Clr: .gray),
        ScreenData(Day: "Wed", Hour: 0, Clr: .gray),
        ScreenData(Day: "Thu", Hour: 0, Clr: .gray),
        ScreenData(Day: "Fri", Hour: 0, Clr: .gray),
        ScreenData(Day: "Sat", Hour: 0, Clr: .gray),
        ScreenData(Day: "Days", Hour: 0, Clr: .gray)
    ]
    
    init() {
        
    }
    
    @State var graphtype: String = ""
    @State var date = Calendar.current.dateComponents([.weekday], from: .now).weekday

    func addday(day: String, hour: Int) {
        ScreenTimeData.append(ScreenData(Day: day, Hour: hour, Clr: .red))
        if let user = viewmodel.user {
            self.su = user.sun
            self.m = user.mon
            self.tu = user.tue
            self.w = user.wed
            self.th = user.thu
            self.f = user.fri
            self.sa = user.sat
            
        }
    }
    
    func addinchart() {
        if (date == 1) {
            day = "Sun"
            
            if let user = viewmodel.user {
                ScreenTimeData.remove(at: 7)
                addday(day: "Sun", hour: Int(user.sun))
            }
//            cdata.addinChartData(index: 1, day: "Mon", h: 3, clr: .red)
//            print(data[1])
        }
        else if(date == 2) {
            day = "Mon"
            
            if let user = viewmodel.user {
                ScreenTimeData.remove(at: 7)
                addday(day: "Mon", hour: Int(user.mon))
                ScreenTimeData[0] = ScreenData(Day: "Sun", Hour: su, Clr: .gray)
            }
        }
        else if(date == 3) {
            day = "Tue"
            
            if let user = viewmodel.user {
                ScreenTimeData.remove(at: 7)
                addday(day: "Tue", hour: Int(user.tue))
                ScreenTimeData[0] = ScreenData(Day: "Sun", Hour: su, Clr: .gray)
                ScreenTimeData[1] = ScreenData(Day: "Mon", Hour: m, Clr: .gray)
            }
        }
        else if(date == 4) {
            day = "Wed"
            
            if let user = viewmodel.user {
                ScreenTimeData.remove(at: 7)
                addday(day: "Wed", hour: Int(user.wed))
                ScreenTimeData[0] = ScreenData(Day: "Sun", Hour: su, Clr: .gray)
                ScreenTimeData[1] = ScreenData(Day: "Mon", Hour: m, Clr: .gray)
                ScreenTimeData[2] = ScreenData(Day: "Tue", Hour: tu, Clr: .gray)
            }
        }
        else if(date == 5) {
            day = "Thu"
            
            if let user = viewmodel.user {
                ScreenTimeData.remove(at: 7)
                addday(day: "Thu", hour: Int(user.thu))
                ScreenTimeData[0] = ScreenData(Day: "Sun", Hour: su, Clr: .gray)
                ScreenTimeData[1] = ScreenData(Day: "Mon", Hour: m, Clr: .gray)
                ScreenTimeData[2] = ScreenData(Day: "Tue", Hour: tu, Clr: .gray)
                ScreenTimeData[3] = ScreenData(Day: "Wed", Hour: w, Clr: .gray)
            }
        }
        else if(date == 6) {
            day = "Fri"
            
            if let user = viewmodel.user {
                ScreenTimeData.remove(at: 7)
                addday(day: "Fri", hour: Int(user.fri))
                ScreenTimeData[0] = ScreenData(Day: "Sun", Hour: su, Clr: .gray)
                ScreenTimeData[1] = ScreenData(Day: "Mon", Hour: m, Clr: .gray)
                ScreenTimeData[2] = ScreenData(Day: "Tue", Hour: tu, Clr: .gray)
                ScreenTimeData[3] = ScreenData(Day: "Wed", Hour: w, Clr: .gray)
                ScreenTimeData[4] = ScreenData(Day: "Thu", Hour: th, Clr: .gray)
            }
        }
        else if(date == 7) {
            day = "Sat"

            if let user = viewmodel.user {
                ScreenTimeData.remove(at: 7)
                addday(day: "Sat", hour: Int(user.sat))
                ScreenTimeData[0] = ScreenData(Day: "Sun", Hour: su, Clr: .gray)
                ScreenTimeData[1] = ScreenData(Day: "Mon", Hour: m, Clr: .gray)
                ScreenTimeData[2] = ScreenData(Day: "Tue", Hour: tu, Clr: .gray)
                ScreenTimeData[3] = ScreenData(Day: "Wed", Hour: w, Clr: .gray)
                ScreenTimeData[4] = ScreenData(Day: "Thu", Hour: th, Clr: .gray)
                ScreenTimeData[5] = ScreenData(Day: "Fri", Hour: f, Clr: .gray)
            }
        }
    }
    
    @State var mail = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Header(title: "Screen Time Chart")
            
            ScrollView {
                Button {
                    print(ScreenTimeData[1])
                } label: {
                    VStack {
                        
    //                    Graph
                        withAnimation {
                            Chart {
                                ForEach(ScreenTimeData) { d in
                                    
                                    BarMark(
                                        x: .value("Month", d.Day),
                                        y: .value("View", d.Hour)
                                    )
//                                    .annotation(position: .automatic, content: {
//                                        Text(String(d.Hour))
//                                    })
                                    .annotation(content: {
                                        Text(String(d.Hour))
                                    })
//                                    .annotation(position: .overlay){
//                                        Text(String(d.Hour))
//                                    }
                                    .foregroundStyle(d.Clr)
                                    .cornerRadius(7)
                                }
                            }
                            .frame(height: 200)
                        }
                    }
                }
                .cornerRadius(15)
            }
            Text("Hour:- \(Hour)")
            Text("Second:- \(Second)")
            Text("Minute:- \(Minute)")
        }
        .onChange(of: day){ newValue in
            print(newValue)
            print("Day is changed and Value is reset...!")
            resetTime()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    addinchart()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    addinchart()
                }
            }
            
            if let docid = viewmodel.user {
                print(docid.userId)
                Firestore.firestore().collection("bchart").document(docid.userId).setData([day : Hour], merge: true)
            }
        }
        .onDisappear {
            
        }
        .onReceive(timer) { _ in
            withAnimation(.default) {
                time()
            }
        }
        .task {
            try? await viewmodel.loadCurrentUse()
        }
        .padding()
        .onDisappear {
            storeKey()
        }
    }
}

struct BovChart_Previews: PreviewProvider {
    static var previews: some View {
        BovChartView()
    }
}

struct ScreenData: Identifiable {
    let id = UUID()
    let Day: String
    let Hour: Int
    let Clr: Color
}

//class ForChartData: ObservableObject {
//    @Published var ChartData = [
//        ScreenData(Day: "Sun", Hour: 2, Clr: .blue),
//        ScreenData(Day: "Mon", Hour: 1, Clr: .blue),
//        ScreenData(Day: "Tue", Hour: 6, Clr: .blue),
//        ScreenData(Day: "Wed", Hour: 2, Clr: .blue),
//    ]
//    
//    func addinChartData(index: Int, day: String, h: Int, clr: Color) {
//        ChartData[index] = ScreenData(Day: day, Hour: h, Clr: clr)
//    }
//    
//    
//}
