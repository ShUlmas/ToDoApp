//
//  AuthManager.swift
//  ToDoApp
//
//  Created by O'lmasbek on 08/09/23.
//

import Foundation
import Supabase

class AuthManager {
    static let shared = AuthManager()
    
    let client = SupabaseClient(
        supabaseURL: URL(string: "https://scwjatlkzltqwhmpffti.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjd2phdGxremx0cXdobXBmZnRpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQxNjQxMTAsImV4cCI6MjAwOTc0MDExMH0.-COI442bvOAWD-Gssb7Ph-T7X7Lk-pAw5elr730yRQ4")
    
    private init() {}
    
    //MARK: - REGISTER
    func registerNewUserWithEmail(email: String, password: String) async throws -> AppUser {
        let registrationAuthResponse = try await client.auth.signUp(email: email, password: password)
        guard let session = registrationAuthResponse.session else {
            print("registration error")
            throw NSError()
        }
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    //MARK: - Sign In
    func signInWithEmail(email: String, password: String) async throws -> AppUser {
        let session = try await client.auth.signIn(email: email, password: password)
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    //MARK: - Get current session
    func getCurrentSession() async throws -> AppUser {
        let session = try await client.auth.session
        return AppUser(uid: session.user.id.uuidString, email: session.user.email)
    }
    
    //MARK: - Sign In With Google
    func signInWithGoogle(idToken: String, nonce: String) async throws {
        
    }
    
    //MARK: - Sign out
    func signOut() async throws {
        try await client.auth.signOut()
    }
}
