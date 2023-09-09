//
//  TodoViewModel.swift
//  ToDoApp
//
//  Created by O'lmasbek on 08/09/23.
//

import Foundation
import UIKit

class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    
    var mockData = [
        TodoPayload(text: "homework", userUid: ""),
        TodoPayload(text: "gym", userUid: ""),
        TodoPayload(text: "code", userUid: ""),
        TodoPayload(text: "sleep", userUid: ""),
    ]
    
    //MARK: - Create
    @MainActor
    func createItem(text: String, userUid: String) async throws {
        guard !todos.contains(where: { $0.text.lowercased() == text.lowercased() }) else {
            print("already created")
            throw NSError()
        }
        
        let todo = TodoPayload(text: text, userUid: userUid)
        try await DatabaseManager.shared.createTodoItems(item: todo)
    }
   
    //MARK: - Read
    @MainActor
    func fetchItems(for uid: String) async throws {
         todos = try await DatabaseManager.shared.fetchTodoItems(for: uid)
    }
    //MARK: - Delete
    @MainActor
    func deleteItem(todo: Todo) async throws {
        try await DatabaseManager.shared.deleteTodoItem(id: todo.id)
        todos.removeAll(where: { $0.id == todo.id })
    }
    
    func fetchProfilePhoto(for appUser: AppUser) async throws -> UIImage {
        let data = try await StorageManager.shared.fetchProfilePhoto(for: appUser)
        
        guard let image = UIImage(data: data) else {
            throw NSError()
        }
        return image
    }
}
