//
//  DataServiceMock.swift
//  BasicSwiftUI
//
//  Created by Pablo Erick Cardoso on 01/06/2021.
//

import Foundation
import Combine
import os

class DataServiceMock : IDataService {
    
    override func fecthCourses() -> AnyPublisher<[CourseDTO], Error> {
        let obj : [CourseDTO] = [(.init( id: 1, name: "Rapazito 1")),
                                 .init(id: 2,name: "Rapazito 2"),
                                 .init(id: 3,name:"Valor 3"),
                                 .init(id: 4,name: "Enviou 4")]
        
        return Future<[CourseDTO], Error> { promise in
            promise(.success(obj))
        }
        .delay(for: .init(2), scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
