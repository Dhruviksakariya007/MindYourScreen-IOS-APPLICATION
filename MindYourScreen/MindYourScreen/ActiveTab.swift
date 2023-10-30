//
//  ActiveTab.swift
//  MindYourScreen
//
//  Created by Mac on 02/09/23.
//

import SwiftUI

struct ActiveTab: View {
    @State var SelectedTab = "Home"
//    @AppStorage("LoginStatus") var LoginStatus = false
    let homeactivity = HomeView()
//    @State var showSignInView: Bool = false
    
//    func signout() {
//        try? AuthenticationManager.shared.signOut()
//    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $SelectedTab) {
                    HomeView()
                        .tag("Home")
                        .tabItem() {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    
                    BovChartView()
                        .tag("Graph")
                        .tabItem() {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("Graph")
                        }
                    
                    FocusMode()
                        .tag("Focus")
                        .tabItem() {
                            Image(systemName: "autostartstop.trianglebadge.exclamationmark")
                            Text("Focus Mode")
                        }
                }
//                Button {
//                    Task {
//                        do {
//                            signout()
//                            showSignInView = true
//                        } catch {
//                            print(error)
//                        }
//                    }
//                } label: {
//                    Text("Logout")
//                }
            }
//            .onAppear {
//                let authUse = try? AuthenticationManager.shared.getAuthenticatedUser()
//                self.showSignInView = authUse == nil ? true : false
//            }
//            .fullScreenCover(isPresented: $showSignInView) {
//                NavigationStack {
//                    AuthenticationView(showSignInView: $showSignInView )
//                }
//            }
        }
    }
}

struct ActiveTab_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTab()
    }
}
