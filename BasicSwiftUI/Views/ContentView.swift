//
//  ContentView.swift
//  BasicSwiftUI
//
//  Created by Pablo Erick Cardoso on 15/03/2021.
//

import SwiftUI
import Combine


struct ContentView: View {
    
    @ObservedObject var viewmodel : ContentViewModel
    
    init(viewmodel: ContentViewModel = ContentViewModel()){
        self.viewmodel = viewmodel
    }
    
    @State var simpleTitle : String = "Single Title"
    
    var body: some View {
        switch viewmodel.state {
        case .idle(let courses):
            content(currentState: "idle - loaded", courses: courses)
        case .loading:
            ProgressView("Loading")
        case .error(let error):
            Text("Network error \(error.localizedDescription)")
        case .teste(let currentState):
            content(currentState: currentState)
        default:
            content(currentState: "default")
        }
    }
    
    func content(currentState : String, courses : [Course] = [Course]()) -> some View {
        VStack(alignment: .trailing, spacing: 30){
            Text(simpleTitle)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
            Text("State: \(currentState)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
            HStack{
                List(courses){ course in
                    Text(course.name)
                }
                List(viewmodel.myCourses){ course in
                    Text(course.name)
                }
            }
            
            
            Text(viewmodel.myCourse)
            TextField("Name of Course", text: $viewmodel.myCourse)
                .padding()
                .background(Color.yellow)
                .cornerRadius(14)
            Button(action: {
                viewmodel.myCourses.append(.init(name: viewmodel.myCourse))
                viewmodel.myCourse = ""
            }){
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 0,
                           maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .frame(height:45)
                    .background(Color.green)
                    .cornerRadius(13)
            }
            Button(action: {
                viewmodel.send(event: .onLoadCourses)
            }){
                Text("Busca Web")
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 0,
                           maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .frame(height:45)
                    .background(Color.blue)
                    .cornerRadius(13)
            }
            Button(action: {
                simpleTitle = "Other Title"
                viewmodel.send(event: .onTeste("Yhaaa"))
            }){
                Text("Teste Event and State")
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 0,
                           maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .frame(height:45)
                    .background(Color.red)
                    .cornerRadius(13)
            }
            
        }.padding()
        .background(Color.init(hex: 0xA6CEF6))
        
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewmodel : [Course] = [(.init(name: "aaa rapazito 1")),
                                    .init(name: "rapaz 2"),
                                    .init(name:"valor 3"),
                                    .init(name: "mandou bem 4")
        ]
        ContentView(viewmodel: ContentViewModel(courses: viewmodel))
    }
}
