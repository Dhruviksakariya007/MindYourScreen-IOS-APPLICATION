//
//  SplashScreen.swift
//  MindYourScreen
//
//  Created by Mac on 18/09/23.
//

import SwiftUI

struct signinornot {
    var image: String = "productivity"
    var txt: String = "Mind Your Screen"
}

struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
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
    
    var body: some View {
        if isActive {
            withAnimation(.easeOut) {
                ActiveTab()
            }
        } else {
            VStack {
                VStack {
                    Image(signinornot.init().image)
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                    
                    Text (signinornot.init().txt)
                        .font (Font.custom("Baskerville-Bold", size: 26))
                        .foregroundColor(.black.opacity(0.80))
//                    Button {
//                        Task {
//                            do {
//                                signout()
//                                showSignInView = true
//                            } catch {
//                                print(error)
//                            }
//                        }
//                    } label: {
//                        Text("Logout")
//                    }
                }
                .scaleEffect (size)
                .opacity (opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.05)) {
                        self.size = 0.9
                        self.opacity = 1.0
//                        if showSignInView == false {
//                            isActive = true
//                        }
                    }
                }
            }
            .onAppear {
//                let authUse = try? AuthenticationManager.shared.getAuthenticatedUser()
//                showSignInView = authUse == nil ? true : false
//                if authUse != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        isActive = true
                    }
//                }
            }
//            .fullScreenCover(isPresented: $showSignInView) {
//                NavigationStack {
//                    AuthenticationView(showSignInView: $showSignInView )
//                }
//            }
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                    isActive = true
//                }
//            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
