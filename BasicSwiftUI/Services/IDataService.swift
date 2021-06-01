//
//  IDataService.swift
//  BasicSwiftUI
//
//  Created by Pablo Erick Cardoso on 01/06/2021.
//

import Foundation
import Combine

protocol IDataServiceProtocol {
    func fecthCourses() -> AnyPublisher<[CourseDTO], Error>
}

class IDataService : IDataServiceProtocol & ObservableObject {
    func fecthCourses() -> AnyPublisher<[CourseDTO], Error> {
        return Empty().eraseToAnyPublisher()
    }
}
