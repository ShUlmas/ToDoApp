//
//  Todo.swift
//  ToDoApp
//
//  Created by O'lmasbek on 08/09/23.
//

import Foundation

struct Todo: Codable {
    let id: Int
    let createdAt: String
    let text: String
    let userUid: String
}
