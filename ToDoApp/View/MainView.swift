//
//  MainView.swift
//  ToDoApp
//
//  Created by O'lmasbek on 08/09/23.
//

import SwiftUI

struct MainView: View {
    @State var appUser: AppUser? = nil
    
    var body: some View {
        ZStack {
            if let appUser = appUser {
                TodoView(appUser: appUser)
            } else {
                SignInView(appUser: $appUser)
            }
        }
        .onAppear {
            Task {
                self.appUser = try await AuthManager.shared.getCurrentSession()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
