//
//  CreateTodoView.swift
//  ToDoApp
//
//  Created by O'lmasbek on 09/09/23.
//

import SwiftUI

struct CreateTodoView: View {
    @EnvironmentObject var viewModel: TodoViewModel
    @State var appUser: AppUser
    @State var name: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        AppTextField(placeholder: "name", text: $name)
                        Button {
                            Task {
                                do {
                                    try await viewModel.createItem(text: name, userUid: appUser.uid)
                                    dismiss()
                                } catch {
                                    print("sign in error")
                                }
                            }
                        } label: {
                            Text("Create")
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
                    .padding(.horizontal, 24)
                }
            }
            .navigationTitle("Create todo")
        }
    }
}

struct CreateTodoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTodoView(appUser: .init(uid: "", email: ""))
            .environmentObject(TodoViewModel())
    }
}
