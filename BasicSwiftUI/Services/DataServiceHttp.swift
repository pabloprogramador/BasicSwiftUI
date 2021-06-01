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

class DataServiceHttp : IDataService {
    
    private let apiUrl = URL(string: "https://mocki.io/v1/e2f5245a-8f66-4fe7-b190-8b1d7e746447")!

    override func fecthCourses() -> AnyPublisher<[CourseDTO], Error>{
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
   
}

extension URLRequest {
    func addJsonContentType() -> URLRequest {
        var request = self
            request.addValue( "application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}




