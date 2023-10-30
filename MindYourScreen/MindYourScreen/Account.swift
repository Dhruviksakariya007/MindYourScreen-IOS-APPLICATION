//
//  Account.swift
//  MindYourScreen
//
//  Created by Mac on 17/09/23.
//

import SwiftUI

struct Account: View {
    @State var showSignInView: Bool = false
    
    func signout() {
        try? AuthenticationManager.shared.signOut()
    }
    
    func resertPasword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    @State var ShowAlert: Bool = false
//    func updateEmail() async throws {
//        let email = "dhuloo@gmail.com"
//        try await AuthenticationManager.shared.updateEmail(email: email)
//    }
//
//    func updatePassword() async throws {
//        let password = "122222"
//        try await AuthenticationManager.shared.updatePassword(password: password)
//    }
    @StateObject var viewmodel = BovChartViewModel()
    let Home = HomeView()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section("Profile") {
                        HStack(spacing: 10) {
                            Circle()
    //                            .fill(.gray)
                                .frame(width: 45, height: 45)
                                .overlay {
                                    Image(systemName: "person.crop.circle")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                }
                            
                            if let user = viewmodel.user {
                                Text(user.email)
                                    .accentColor(.black)
                            }
                        }
                    }
                    
                    Section("Settings"){
                        Button {
                            print("Logout")
                            ShowAlert = true
                        } label: {
                            Text("Logout")
                        }
                        .alert(isPresented: $ShowAlert) {
                            Alert(
                                title: Text("Are you sure you want to Logout..?"),
                                message: Text("Your Graphical data will be lost...!"),
                                primaryButton: .destructive(Text("Yes")) {
                                    Task {
                                        do {
                                            signout()
                                            showSignInView = true
                                        } catch {
                                            print(error)
                                        }
                                    }
                                },
                                secondaryButton: .cancel()
                            )
//                            HStack {
//                                Button("OK", role: .cancel){
//                                    Task {
//                                        do {
//                                            signout()
//                                            showSignInView = true
//                                        } catch {
//                                            print(error)
//                                        }
//                                    }
//                                }
//                                Button("Cancle", role: .cancel) {}
//                            }
                        }
                    }
                }
            }
            .task {
                try? await viewmodel.loadCurrentUse()
            }
            .navigationTitle("Profile")
            .onAppear {
                let authUse = try? AuthenticationManager.shared.getAuthenticatedUser()
                self.showSignInView = authUse == nil ? true : false
            }
            .fullScreenCover(isPresented: $showSignInView) {
                NavigationStack {
                    AuthenticationView(showSignInView: $showSignInView )
                }
            }
        }
    }
}

struct Account_Previews: PreviewProvider {
    static var previews: some View {
        Account()
    }
}
