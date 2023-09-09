//
//  DatabaseManager.swift
//  ToDoApp
//
//  Created by O'lmasbek on 08/09/23.
//

import Foundation
import Supabase


class DatabaseManager {
    
    static let shared = DatabaseManager()
    let client = SupabaseClient(
        supabaseURL: URL(string: "https://scwjatlkzltqwhmpffti.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjd2phdGxremx0cXdobXBmZnRpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQxNjQxMTAsImV4cCI6MjAwOTc0MDExMH0.-COI442bvOAWD-Gssb7Ph-T7X7Lk-pAw5elr730yRQ4")
    
    private init() {}
    
    func createTodoItems(item: TodoPayload) async throws {
        try await client.database.from("todos").insert(values: item).execute()
        
    }
    
    func fetchTodoItems(for uid: String) async throws -> [Todo] {
        let response = try await client.database.from("todos").select().equals(column: "user_uid", value: uid).order(column: "created_at", ascending: false).execute()
        let data = response.underlyingResponse.data
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let todos = try decoder.decode([Todo].self, from: data)
        print(todos)
        return todos
    }
    
    func deleteTodoItem(id: Int) async throws {
        try await client.database.from("todos").delete().eq(column: "id", value: id).execute()
    }
}
