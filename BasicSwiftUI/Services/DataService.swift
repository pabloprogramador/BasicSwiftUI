//
//  DataService.swift
//  BasicSwiftUI
//
//  Created by Pablo Erick Cardoso on 18/03/2021.
//
//class func checkUrl(urlString: String, finished: ((isSuccess: Bool)->Void) {
import Foundation
import Combine
import os

struct DataService {
    
    private static let apiUrl = URL(string: "https://mocki.io/v1/e2f5245a-8f66-4fe7-b190-8b1d7e746447")!
    
    private static let agent = NetworkAgent()

    static func fecthCoursesPro() -> AnyPublisher<[CourseDTO], Error>{
        let request = URLRequest(url: apiUrl)

            return URLSession.shared
                .dataTaskPublisher(for: request)
                .tryMap() { element -> Data in
                        guard let httpResponse = element.response as? HTTPURLResponse,
                            httpResponse.statusCode == 200 else {
                                throw URLError(.badServerResponse)
                            }
                        return element.data
                        }
                .decode(type: [CourseDTO].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    
    }
    static func fecthCoursesProLixo() -> AnyPublisher<[CourseDTO], Error>{
        //var result : [CourseDTO] = [CourseDTO]()
        var request = URLRequest(url: apiUrl)
            .addJsonContentType()
        request.httpMethod = "GET"
        
       // debugPrint(String(decoding: bodyString, as: UTF8.self))
        return agent.run(request)
    }
    
    static func fecthCoursesPro2() -> AnyPublisher<[Course], Error> {
        let lixo : [Course] = [(.init(name: "xxaaa rapazito 1")),
                                    .init(name: "rxxapaz 2"),
                                    .init(name:"vxxalor 3"),
                                    .init(name: "xxxmandou bem 4")]
        
        return Future<[Course], Error> { promise in
            promise(.success(lixo))
        }
        .delay(for: .init(2), scheduler: RunLoop.main)
        .eraseToAnyPublisher()
     }
    
   
}

extension URLRequest {
    func addJsonContentType() -> URLRequest {
        var request = self
            request.addValue( "application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}




