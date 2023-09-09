//
//  SignInView.swift
//  ToDoApp
//
//  Created by O'lmasbek on 08/09/23.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject var viewModel: SignInViewViewModel = SignInViewViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRegistrationPresented: Bool = false
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text("Enter the following to sign in")
                    .font(Font.custom("Rubik-Bold", size: 30))
                    .multilineTextAlignment(.center)
                Spacer()
                AppTextField(placeholder: "Email address", text: $email)
                
                AppSecureField(placeholder: "Password", text: $password)
                    .padding(.bottom, 12)
                Button {
                    isRegistrationPresented.toggle()
                } label: {
                    Text("If you new user? Register here")
                        .foregroundColor(Color.accentColor)
                        .font(Font.custom("Rubik-Medium", size: 15))
                        .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 12)
                
                Button {
                    Task {
                        do {
                            let appUser = try await viewModel.signInWithEmail(email: email, password: password)
                            self.appUser = appUser
                        } catch {
                            print("sign in error")
                        }
                    }
                } label: {
                    Text("Sign In")
                        .foregroundColor(Color.white)
                        .font(Font.custom("Rubik-Bold", size: 15))
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(16)
                Spacer()
            }
            .sheet(isPresented: $isRegistrationPresented) {
                RegistrationView(appUser: $appUser)
                    .environmentObject(viewModel)
            }
        }
        .padding(.horizontal, 24)
    }
    
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(appUser: .constant(.init(uid: "", email: "")))
    }
}
