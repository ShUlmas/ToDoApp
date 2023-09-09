//
//  HomeView.swift
//  ToDoApp
//
//  Created by O'lmasbek on 08/09/23.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        if let appUser = appUser {
            VStack {
                Text(appUser.uid)
                
                Text(appUser.email ?? "no email")
                
                Button {
                    Task {
                        do {
                            try await AuthManager.shared.signOut()
                            self.appUser = nil
                        } catch {
                            print("unable to sign out")
                        }
                    }
                } label: {
                    Text("sign out")
                }

            }
            .onAppear {
                Task {
                    do {
                        //try await TodoViewModel().createItem(text: "First item", userUid: appUser.uid)
                        try await TodoViewModel().fetchItems(for: appUser.uid)
                    } catch {
                        print("not fetched")
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(appUser: .constant(.init(uid: "1234", email: nil)))
    }
}
