//
//  FocusMode.swift
//  MindYourScreen
//
//  Created by Mac on 06/09/23.
//

import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings

//extension DeviceActivityName {
//    static let daily = Self("Daily")
//}
//extension DeviceActivityEvent.Name {
//    static let encoraged = Self("Encoraged")
//}

//
//let schedule = DeviceActivitySchedule (intervalStart: DateComponents(hour: 0, minute: 0),
//                                       intervalEnd: DateComponents(hour: 23, minute: 59),
//                                       repeats: true)
//let center = DeviceActivityCenter()
//let startMonitor: ()? = try? center.startMonitoring(.daily, during: schedule)
//let model = FocusMode().model
//let event: [DeviceActivityEvent.Name: DeviceActivityEvent] = [.encoraged: DeviceActivityEvent(applications: model.applicationTokens, threshold: DateComponents(minute: 5))]


//class MyMonitor: DeviceActivityMonitor {
//    let store = ManagedSettingsStore()
//    override func intervalDidStart (for activity: DeviceActivityName) {
//        super.intervalDidStart (for: activity)
//        print("Device Activity Is Running..!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
//        let model = FocusMode().model
//        let apps = model.applicationTokens
//        store.shield.applications = apps.isEmpty ? nil : apps
//        
//    }
    
//    override func intervalDidEnd(for activity: DeviceActivityName) {
//        super.intervalDidEnd (for: activity)
//        store.shield.applications = nil
//    }
//    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        super.eventDidReachThreshold(event, activity: activity)
//        store.shield.applications = nil
//    }
//}

struct FocusMode: View {
    @State var Picker: Bool = false
    @State var ShowSheet: Bool = false
    @State var ShowAlert: Bool = false
    @State var model = FamilyActivitySelection()
    var titlemodel = PickATime()
    @State var selectedDate = Date()
    @State var txt: String = "SET A TITLE"
    @State var lis = ["Instagram", "facebook", "Amazon", "Flipcart"]
//    let selectedapps = model.applicationTokens
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    print("Header")
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(
                            Font.custom("Inter", size: 30)
                                .weight(.medium)
                        )
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Focus Mode")
                    .font(
                        Font.custom("Inter", size: 23)
                            .weight(.medium)
                    )
                Spacer()
                Button {
                    print("Profile")
//                    Task {
//                        do {
//                            signout()
////                            showSignInView = true
//                        } catch {
//                            print(error)
//                        }
//                    }
                } label: {
                    Image(systemName: "person.crop.circle")
                        .font(
                            Font.custom("Inter", size: 30)
                                .weight(.medium)
                        )
                        .accentColor(.black)
                }
            }
            
            NavigationStack {
                List {
//                        ForEach(lis, id: \.self) { lis in
//                            Text(lis)
//                        }
//                        .onDelete { IndexSet in
//                            lis.remove(atOffsets: IndexSet)
//                        }
                        Button {
                            Picker = true
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Application")
                            }
                        }
                        .familyActivityPicker(isPresented: $Picker, selection: $model)
                        .onChange(of: model) { newValue in
                            print(newValue)
                            let applications = model.applications
                            let applicationTokens = model.applicationTokens
                            let applicationCategory = model.categories
                            
                            print("Applications are:= " , applications)
                            print("Application's Token are:= " , applicationTokens)
                            print("Application's Category are:= " , applicationCategory) 
                        }
                    Section(header: Text(txt)) {
                        Text("Instagram")
                        Text("Snapchat")
                        Text("Opal")
                        Text("Twiter")
                    }
                }
                .cornerRadius(20)
                HStack {
                    
//                    Menu {
//                        Text("1 Minute")
//                        Text("5 Minute")
//                        Text("10 Minute")
//                        Text("30 Minute")
//                        Text("1 Hour")
//                    } label: {
//                        Text("Select a Time")
//                    }

                    
                    
                    DatePicker("Pick a time", selection: $selectedDate, displayedComponents: [.hourAndMinute])
                }
                .padding()
            }
            
            Button {
//                Picker = true
//                ShowSheet = true
                ShowAlert = true
            } label: {
                    Text("Focus")
                        .frame(width: 240, height: 50, alignment: .center)
                        .background(.blue.opacity(0.3))
                    .cornerRadius(20)
            }
//            .familyActivityPicker(isPresented: $Picker, selection: $model)
//            .onChange(of: $model, perform: { newValue in
//                let aps = model.applications
//            })
//            .sheet(isPresented: $ShowSheet, onDismiss: {}){
//                PickATime()
//            }
            .alert("Give a title for application group", isPresented: $ShowAlert) {
                TextField("Enter Text", text: $txt)
                Button("OK", role: .cancel){}
                    .familyActivityPicker(isPresented: $Picker, selection: $model)
                    
            }

//            .onChange(of: $model) { newValue in
//                print(newValue)
//            }
        }
        .padding()
    }
}

struct FocusMode_Previews: PreviewProvider {
    static var previews: some View {
        FocusMode()
    }
}

struct PickATime: View {
    @State var selectedDate = Date()
    var body: some View {
        VStack {
            
            DatePicker("Pick a Time", selection: $selectedDate, displayedComponents: [.hourAndMinute])
        }
        .padding()
        
    }
}


