//
//  ContentView.swift
//  Devote
//
//  Created by Anastasia Karunos on 10/30/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false


    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // MARK: - FUNCTION
    

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // CORE VIEW

    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - MAIN VIWE
                
                VStack {
                    HStack(spacing: 10) {
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        
                        Spacer()
                        
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(
                                Capsule().stroke(Color.white, lineWidth: 2)
                                )
                        Button {
                            // TOGGLE APPEARANCE
                            isDarkMode.toggle()
                            print("should play sound??")
                            playSound(sound: "sound-tap", type: "mp3")
                        } label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        }

                    }
                    .padding()
                    .foregroundColor(.white)
                    // MARK: - HEADER
                    Spacer(minLength: 80)
                    // MARK: - NEW TASK BUTTON
                    
                    Button {
                        showNewTaskItem = true
                        print("please call play sound")
                        playSound(sound: "sound-ding", type: "mp3")
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                        .clipShape(Capsule()))
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
                                

                    // DOG!: TASKS
                    List {
                        ForEach(items) { item in
                            ListRowItemView(item: item)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                .frame(maxWidth: 640)
                } //VSTACK
                .blur(radius: showNewTaskItem ?  8.0 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5))
                // DOG!: NEW TASK ITEM
                if showNewTaskItem {
                    BlankView(
                        backgroundColor: isDarkMode ? Color.black : Color.gray,
                        backgroundOpacity: isDarkMode ?
                        0.3 : 0.5)
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
            } //ZSTACK
            .navigationBarTitle("Daily Activities", displayMode: .large)
            .navigationBarHidden(true)
            .background(
                BackgroundImageView()
                    .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
            )
            .background(backgroundGradien.ignoresSafeArea(.all))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
    }
}
