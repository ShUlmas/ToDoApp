//
//  TodoView.swift
//  ToDoApp
//
//  Created by O'lmasbek on 09/09/23.
//

import SwiftUI
import PhotosUI

struct TodoView: View {
    
    @StateObject var todoViewModel: TodoViewModel = TodoViewModel()
    
    @State var appUser: AppUser
    @State var showPhotoActionSheet = false
    @State var showPhotoLibrary = false
    @State var selectedPhoto: PhotosPickerItem?
    @State var profilImage = Image(systemName: "timelapse")
    @State var showLoading = false
    @State var showProfilImageLoadingView: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack {
                        ForEach(todoViewModel.todos, id: \.text) { todo in
                            TodoItemView(todo: todo)
                                .environmentObject(todoViewModel)
                        }
                    }
                    .padding(.horizontal)
                }
                if showLoading { LoadingView() }
            }
            .onAppear {
                showProfilImageLoadingView = true
                // Simulating the process...
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showProfilImageLoadingView = false
                }
                
                showLoading = true
                // Simulating the process...
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showLoading = false
                }
                Task {
                    do {
                        try await todoViewModel.fetchItems(for: appUser.uid)
                        let uiimage = try await todoViewModel.fetchProfilePhoto(for: appUser)
                        await MainActor.run {
                            profilImage = Image(uiImage: uiimage)
                        }
                    } catch {
                        print("fetch error")
                    }
                }
             
            }
            .navigationTitle("Todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    profilImage
                        .resizable()
                        .frame(width: 32, height: 32)
                        .scaledToFill()
                        .cornerRadius(16)
                        .onTapGesture {
                            showPhotoActionSheet.toggle()
                        }
                        .confirmationDialog("Select a profile photo", isPresented: $showPhotoActionSheet) {
                            Button {
                                showPhotoLibrary.toggle()
                            } label: {
                                Text("Photo library")
                            }

                        }
                        .photosPicker(isPresented: $showPhotoLibrary, selection: $selectedPhoto, photoLibrary: .shared())
                        .onChange(of: selectedPhoto) { newValue in
                            guard let photoItem = selectedPhoto else {
                                return
                            }
                            
                            Task {
                                if let photoData = try await photoItem.loadTransferable(type: Data.self),
                                   let uiimage = UIImage(data: photoData) {
                                    try await StorageManager.shared.uploadProfilePhoto(for: appUser, photoData: photoData)
                                    await MainActor.run {
                                        profilImage = Image(uiImage: uiimage)
                                    }
                                }
                            }
                        }
                        .contextMenu {
                            Button {
                                Task {
                                    do {
                                        try await AuthManager.shared.signOut()
                                    } catch {
                                        print("error signing out")
                                    }
                                }
                            } label: {
                                Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                                
                            }
                        }
                        .overlay {
                            if showProfilImageLoadingView {
                                ZStack {
                                    Color("universalColor")
                                    ProgressView()
                                }
                                .cornerRadius(40)
                            }
                        }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        CreateTodoView(appUser: appUser)
                            .environmentObject(todoViewModel)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color("universalColor"))
                    }
                }
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(appUser: .init(uid: "", email: ""))
    }
}
