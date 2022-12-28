//
//  NewTaskItemView.swift
//  Devote
//
//  Created by Anastasia Karunos on 11/1/22.
//

import SwiftUI

struct NewTaskItemView: View {
    
    @AppStorage("IsDarkMode") private var isDarkMode: Bool = true
    @Environment(\.managedObjectContext) private var viewContext
    @State private var task: String = ""
    @Binding var isShowing: Bool
    
    private var isButtonDisabled: Bool {
        return task.isEmpty
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            task = ""
            hideKeybaord()
            isShowing = false
            
        }
    }

    
    var body: some View {
        
        VStack {
            Spacer()
            
            VStack {
                VStack(spacing: 16){
                    TextField("New Task", text: $task)
                        .foregroundColor(.pink)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .padding()
                        .cornerRadius(16)
                        .background(
                            isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                        )
                    Button {
                        addItem()
                        playSound(sound: "sound-ding", type: "mp3")
                    } label: {
                        Spacer()
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Spacer()
                    }
                    .disabled(isButtonDisabled)
                    .onTapGesture {
                        if isButtonDisabled {
                            playSound(sound: "sound-tap", type: "mp3")
                        }
                    }
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(isButtonDisabled ? Color.blue : Color.pink)
                    .cornerRadius(10)
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                .background(isDarkMode ? Color(uiColor: UIColor.secondarySystemBackground) : .white)
                .cornerRadius(16)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
                .frame(maxWidth: 640)
            }
        }
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
            .previewDevice("Iphone 12 Pro")
            .background(Color.gray.edgesIgnoringSafeArea(.all))
            .preferredColorScheme(.dark)
        
    }
}
