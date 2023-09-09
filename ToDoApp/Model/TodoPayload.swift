//
//  TodoPayload.swift
//  ToDoApp
//
//  Created by O'lmasbek on 08/09/23.
//

import Foundation

struct TodoPayload: Codable {
    let text: String
    let userUid: String
    
    private enum CodingKeys: String, CodingKey {
        case text
        case userUid = "user_uid"
    }
}
