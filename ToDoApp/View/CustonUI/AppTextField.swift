//
//  AppTextField.swift
//  ToDoApp
//
//  Created by O'lmasbek on 08/09/23.
//

import SwiftUI

struct AppTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(text: $text) {
            Text(placeholder)
                .font(Font.custom("Rubik-Medium", size: 15))
                
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .padding(.horizontal)
        .frame(height: 55)
        .background(Color.gray.opacity(0.2))
        .frame(maxWidth: .infinity)
        .cornerRadius(16)
    }
}

struct AppTextField_Previews: PreviewProvider {
    static var previews: some View {
        AppTextField(placeholder: "Email address", text: .constant(""))
    }
}
