//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitor
//
//  Created by Mac on 20/09/23.
//

import DeviceActivity
import FamilyControls
import ManagedSettings
import SwiftUI


extension DeviceActivityName {
    static let daily = Self("Daily")
}
extension DeviceActivityEvent.Name {
    static let encoraged = Self("Encoraged")
}


let schedule = DeviceActivitySchedule (
    intervalStart: DateComponents(hour: 0, minute: 0),
    intervalEnd: DateComponents(hour: 23, minute: 59),
    repeats: true
)

let center = DeviceActivityCenter()
let startMonitor: ()? = try? center.startMonitoring(.daily, during: schedule)
let model = FocusMode().model
let event: [DeviceActivityEvent.Name: DeviceActivityEvent] = [.encoraged: DeviceActivityEvent(applications: model.applicationTokens, threshold: DateComponents(minute: 5))]

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        print("Device Activity Is Running..!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        let model = FocusMode().model
        let apps = model.applicationTokens
        store.shield.applications = apps.isEmpty ? nil : apps
        // Handle the start of the interval.
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        super.intervalDidEnd (for: activity)
        store.shield.applications = nil
        // Handle the end of the interval.
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        store.shield.applications = nil
        
        // Handle the event reaching its threshold.
    }
}
