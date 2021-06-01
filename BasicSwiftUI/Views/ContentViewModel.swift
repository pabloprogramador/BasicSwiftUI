//
//  ContentViewModel.swift
//  BasicSwiftUI
//
//  Created by Pablo Erick Cardoso on 18/03/2021.
//

import Foundation
import Combine
import SwiftUI
import os

class ContentViewModel : ObservableObject {
    @Published private(set) var state = AppState.idle([Course]())
    @Published var myCourses = [Course]()
    @Published var myCourse : String = ""
    
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.userInput(input: input.eraseToAnyPublisher()),
                Self.loadCourses()
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    convenience init(courses: [Course]) {
        self.init()
        //self.myCourses = courses
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}

extension ContentViewModel{
    
    enum AppState {
        case idle([Course])
        case loaded
        case loading
        case error(Error)
        case teste(String)
    }
    
    enum Event {
        case onError(Error)
        case onLoaded([Course])
        case onLoading
        case onLoadCourses
        case onApper
        case onTeste(String)
        case onCancel
    }
    
    static func reduce (_ state : AppState, _ event : Event) -> AppState{
        
        switch state {
        case .idle:
            switch event {
            case .onTeste(let currentState):
                return .teste(currentState)
            case .onLoadCourses:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case .onLoaded(let list):
                return .idle(list)
            case .onCancel:
                return .loading
            default:
                return state
            }
        default:
            return state
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<AppState, Event> {
        Feedback { _ in input }
    }
    
    static func loadCourses() -> Feedback<AppState, Event> {
        Feedback { (state: AppState) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return DateService.Get.fecthCourses()
                .map({Event.onLoaded(transformDTO(coursesDTO: $0))})
                .catch {Just(Event.onError($0))}
                .eraseToAnyPublisher()
        }
    }
    
    static func transformDTO(coursesDTO : [CourseDTO]) -> [Course]{
        var courses = [Course]()
        for courseDTO in coursesDTO{
            courses.append(Course(name: courseDTO.name))
        }
        return courses
    }
}



//#if DEBUG
//extension ContentViewModel{
//    convenience init(courses: [Course]) {
//      self.init()
//      self.courses = courses
//      self.myname = "ate aqui mudou"
//   }
//}
//#endif
