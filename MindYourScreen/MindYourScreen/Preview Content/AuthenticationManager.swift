//  AuthenticationManager.swift
//  MindYourScreen
//
//  Created by Mac on 15/09/23.

import Foundation
import SwiftUI
import FirebaseAuth
import Firebase
import AuthenticationServices


struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photourl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photourl = user.photoURL?.absoluteString 
    }
    
}

enum AuthProviederOption: String {
    case apple = "apple.com"
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() { }
    
    // check's that user is already signedin
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        print(user)
        return AuthDataResultModel(user: user)
    }
}

extension AuthenticationManager {
    // signin of the use
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataresult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataresult.user)
    }
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        if !email.isEmpty && !password.isEmpty {
            print("Email or password is empty ***********")
        }
        let authDataresult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataresult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updateEmail(to: email)
    }
    
    func signOut() throws {
        try? Auth.auth().signOut()
    }
}

extension AuthenticationManager {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel{
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idTokem, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel{
        let credential = OAuthProvider.credential(withProviderID: AuthProviederOption.apple.rawValue, idToken: tokens.token, rawNonce: tokens.nonce)
        return try await signIn(credential: credential)
    }
     
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel{
        let authDataresult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataresult.user)
    }
}
