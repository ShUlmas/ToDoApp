//
//  TodoItemView.swift
//  ToDoApp
//
//  Created by O'lmasbek on 09/09/23.
//

import SwiftUI

struct TodoItemView: View {
    @EnvironmentObject var viewModel: TodoViewModel
    
    @State var todo: Todo
    @State var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Image(systemName: "trash")
                    .font(Font.custom("Rubik-Bold", size: 20))
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.white)
                    .frame(width: 80, height: 80)
                    .background(Color.red)
                    .cornerRadius(30)
                    .onTapGesture {
                        Task {
                            do {
                                try await viewModel.deleteItem(todo: todo)
                            } catch {
                                print("error deleting")
                            }
                        }
                    }
            }
            .background(Color("lightAndDark"))
            
            
            
            ZStack {
                Color("universalColor")
                HStack() {
                    VStack {
                        HStack {
                            Text(todo.text)
                                .foregroundColor(Color.white)
                                .font(Font.custom("Rubik-Medium", size: 20))
                            .padding(.leading, 24)
                            Spacer()
                        }
                        HStack {
                            Text(todo.createdAt.dateFormatter(style: .long)!)
                                .foregroundColor(Color.white.opacity(0.7))
                                .font(Font.custom("Rubik-Regular", size: 17))
                                .padding(.leading, 24)
                            Spacer()
                        }
                    }
                    Spacer()
                }
                
            }
            .cornerRadius(30)
            .offset(x: offset)
            
            
        }
        .frame(height: 80)
        .cornerRadius(30)
        .gesture(
            DragGesture()
                .onChanged(onChange(value:))
                .onEnded(onEnd(value:))
        )
    }
    
    func onChange(value: DragGesture.Value) {
        if value.translation.width < 0 {
            withAnimation {
                offset = -88
            }
        } else {
            withAnimation {
                offset = 0
            }
        }
    }
    func onEnd(value: DragGesture.Value) {
        
    }
}

struct TodoItemView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemView(todo: .init(id: 0, createdAt: "", text: "", userUid: ""))
            .environmentObject(TodoViewModel())
    }
}

extension String {
    func dateFormatter(style: DateFormatter.Style) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        formatter.dateStyle = style
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: Date())
    }
}
