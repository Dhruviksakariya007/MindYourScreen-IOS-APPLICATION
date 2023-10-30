//
//  AuthenticationView.swift
//  MindYourScreen
//
//  Created by Mac on 13/09/23.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
    
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
    
}

final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email or password not found...!")
            return
        }
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email or password not found...!")
            return
        }
        let authDataResult = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        try await userManager.shared.createNewUser(auth: authDataResult)
    }
    
}


struct GoogleSignInResultModel {
    let idTokem: String
    let accessToken: String
}

@MainActor
final class AuthenticationViewModel: NSObject, ObservableObject {
    
    private var currentNonce: String?
    @Published var didSignInwithApple: Bool = false
    
    @MainActor
    func topViewController (controller: UIViewController? = nil) -> UIViewController? {
        
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController (controller: presented)
        }
        return controller
    }
    
    func signInGoogle() async throws {
        guard let topVC = topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idTokem: idToken, accessToken: accessToken)
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
        try await userManager.shared.createNewUser(auth: authDataResult)
        
    }
    
    func signInApple() async throws { 
         startSignInWithAppleFlow()
        
    }
    
    func startSignInWithAppleFlow() {
        
        guard let appletopVC = topViewController() else {
            return
        }
         
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = appletopVC
      authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }

        
    
}

struct SignInWithAppleResult {
    let token: String
    let nonce: String
}

extension AuthenticationViewModel: ASAuthorizationControllerDelegate {
    
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      
      guard
        let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
        let appleIDToken = appleIDCredential.identityToken,
        let idTokenString = String(data: appleIDToken, encoding: .utf8),
        let nonce = currentNonce else {
          print("Error")
          return
      }
      
      let tokens = SignInWithAppleResult(token: idTokenString, nonce: nonce)
      
      Task {
          do {
              try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
              didSignInwithApple = true
          } catch {
              print(error)
          }
      }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

struct AuthenticationView: View {
    
    @StateObject var viewModel = SignInEmailViewModel()
    @StateObject var vmodel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
    //            Manual Signin
                TextField("Enter Email", text: $viewModel.email)
                    .padding()
                    .background (Color(.systemGray5))
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 5)
//                    .textCase(.lowercase)
                
                SecureField("Enter Password", text: $viewModel.password)
                    .padding()
                    .background (Color(.systemGray5))
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 5)
                    .padding(.top, 5)
                
                Button {
                    
//                    if viewModel.email.isEmpty {
//                        print("empty")
//                    }
                    Task {
                         do {
                            try await viewModel.signUp()
                            showSignInView = false
                            return
                        } catch {
                            print(error)
                        }
                        
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            return
                        } catch {
                            print(error)
                        }
                        
                        do {
                            if viewModel.email.isEmpty {
                                print("dge")
                            }
                        } catch {
                            print(error)
                        }
                        
                    }
                    
                } label: {
                    Text("Signin")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background (Color.blue)
                        .cornerRadius(13) 
                }
                .padding(.top, 10)
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                    Task {
                        do {
                            try await vmodel.signInGoogle()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }
                
                Button {
                    Task {
                        do {
                            try await vmodel.signInApple()
//                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                        .allowsHitTesting(false)
                }
                .onChange(of: vmodel.didSignInwithApple, perform: { newValue in
                    if newValue  {
                        showSignInView = false
                    }
                })
                .frame(height: 50)
                .cornerRadius(10)

                
                Spacer()
                
            }
            .navigationTitle("Sign In")
            .padding()
        }
            
        
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(showSignInView: .constant(false))
    }
}
