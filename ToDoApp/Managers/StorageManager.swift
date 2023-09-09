//
//  StorageManager.swift
//  ToDoApp
//
//  Created by O'lmasbek on 09/09/23.
//

import Foundation
import SupabaseStorage


class StorageManager {
    static let shared = StorageManager()
    
    let secret = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjd2phdGxremx0cXdobXBmZnRpIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5NDE2NDExMCwiZXhwIjoyMDA5NzQwMTEwfQ.Ya_uBIt8rqQHzG7FaFrV7TEkFP7EFZV203iIqStM19M"
    private let apikey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjd2phdGxremx0cXdobXBmZnRpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQxNjQxMTAsImV4cCI6MjAwOTc0MDExMH0.-COI442bvOAWD-Gssb7Ph-T7X7Lk-pAw5elr730yRQ4"
    
    lazy var storage = SupabaseStorageClient(
        url: "https://scwjatlkzltqwhmpffti.supabase.co/storage/v1",
        headers: [
            "Authorization" : "Bearer \(secret)",
            "apikey" : apikey
        ])
        
    func uploadProfilePhoto(for user: AppUser, photoData: Data) async throws {
        let file = File(
            name: "profil_photo",
            data: photoData,
            fileName:"profil_photo.jpg",
            contentType: "jpg")
        
        do {
            let result = try await storage.from(id: "images").update(
                path: "\(user.uid)/profile_photo.jpg",
                file: file,
                fileOptions: FileOptions(cacheControl: "3600"))
            print(result)
        } catch {
            let result = try await storage.from(id: "images").upload(
                path: "\(user.uid)/profile_photo.jpg",
                file: file,
                fileOptions: FileOptions(cacheControl: "3600"))
            print(result)
        }
        
        
    }
    
    func fetchProfilePhoto(for appUser: AppUser) async throws -> Data {
        let data = try await storage.from(id: "images").download(path: "\(appUser.uid)/profile_photo.jpg")
        return data
    }
    
}
