//
//  RegistrationView.swift
//  ToDoApp
//
//  Created by O'lmasbek on 08/09/23.
//

import SwiftUI

struct RegistrationView: View {
    
    @EnvironmentObject var viewModel: SignInViewViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(\.dismiss) private var dismiss
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text("Enter the following to register")
                    .font(Font.custom("Rubik-Bold", size: 30))
                    .multilineTextAlignment(.center)
                Spacer()
                AppTextField(placeholder: "Email address", text: $email)
                
                AppSecureField(placeholder: "Password", text: $password)
                    .padding(.bottom, 30)
                
                Button {
                    Task {
                        do {
                            let appUser = try await viewModel.registerNewUserWithEmail(email: email, password: password)
                            self.appUser = appUser
                            dismiss.callAsFunction()
                        } catch {
                            print("sign in error")
                        }
                    }
                } label: {
                    Text("Register")
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
        }
        .padding(.horizontal, 24)
    }
    
}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(appUser: .constant(.init(uid: "1234", email: nil)))
            .environmentObject(SignInViewViewModel())
    }
}
