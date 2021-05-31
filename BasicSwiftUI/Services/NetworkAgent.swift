//
//  NetworkAgent.swift
//  BasicSwiftUI
//
//  Created by Pablo Erick Cardoso on 30/03/2021.
//

import Foundation
import Combine
import os

struct NetworkAgent {
    
    
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        let requestURL = request.url?.absoluteString
        debugPrint("RequestURL: \(request.url?.absoluteString): \(request.httpBody)" )
        if let body = request.httpBody {
            Logger.api.debug("Url: \(request.url?.absoluteString ?? "", privacy: .public)). Body \(String(data: body, encoding: .utf8) ?? "no body", privacy: .public)")
        //Crashlytics.crashlytics()
          //  .log("Url: \(request.url?.absoluteString). Body \(String(data: body, encoding: .utf8))")
        } else{
            Logger.api.debug("Url: \(request.url?.absoluteString ?? "", privacy: .public))")
        }
        
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap {try analyseResponse(data: $0.data, response: $0.response, requestURL: requestURL ?? "couldn't get requestURL")}
            //.mapError(transformError)
            .handleEvents(receiveOutput: { Logger.api.info("api response: \(String(decoding: $0, as: UTF8.self), privacy: .public))") })
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
          //  .tryCatch({catchError(error: $0)})
            .eraseToAnyPublisher()
    }

    func analyseResponse(data: Data, response: URLResponse, requestURL: String) throws -> Data {
        let responseString = String(data: data, encoding: .utf8)
        let errorCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        //Crashlytics.crashlytics().log(responseString ?? "no Body")
      //  saveToFile(response: responseString ?? "no Body", request: requestURL)
        Logger.api.debug("api response: \(responseString ?? "no Body", privacy: .public)) - analyseResponse - code: \(errorCode, privacy: .public)")
        Logger.api.debug("response length: \(responseString?.count ?? 0, privacy: .public)")
        Logger.api.debug("last 20 Characters: \(responseString?.suffix(20) ?? "empty", privacy: .public)")
       // try getError(statusCode: errorCode)
        return data
    }
    
    func saveToFile(response: String, request: String) {
        let filename = getDocumentsDirectory().appendingPathComponent(request + ":" + UUID().uuidString)
        do {
            try response.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch let error{
            Logger.api.error("couldn't save response: \(error.localizedDescription, privacy: .public)")
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
//    func transformError(error: Error) -> Error {
//        if error is JiraApiError {
//            Logger.api.error("Jira Error detected: \(error.localizedDescription, privacy: .public)")
//            return error
//        }
//
//        if let urlError = error as? URLError {
//        Crashlytics.crashlytics().log("\(urlError.errorCode): \(error.localizedDescription) : \(urlError.networkUnavailableReason)")
//        Crashlytics.crashlytics().record(error: error)
//        Logger.api.error("Errors: \(urlError.errorCode, privacy: .public): \(String(urlError.code.rawValue), privacy: .public) : \(error.localizedDescription, privacy: .public)")
//        } else {
//            Logger.api.error("Errors: \(error.localizedDescription, privacy: .public)")
//        }
//        switch error {
//        case URLError.cannotFindHost, URLError.cannotConnectToHost:
//            return JiraApiError.hostNotFound
//        default:
//            return JiraApiError.unknownError
//        }
//    }
    
//    func getError(statusCode: Int) throws {
//        switch statusCode {
//        case 200, 0:
//            break
//        case 401:
//            throw JiraApiError.unauthorized
//        case 403:
//            throw JiraApiError.recaptchaRequired
//        default:
//            throw JiraApiError.unknownError
//        }
//    }
}

//extension URLRequest {
//    func addBasicAuthenticationHeader(credentials: Credentials) -> URLRequest {
//        var request = self
//        if let authToken  = credentials.authCookie{
//            let authString = "atlassian.xsrf.token=\(authToken.authToken); JSESSIONID=\(authToken.sessionId)"
//            Logger.api.info("Cookie based auth, \(authString, privacy: .public)")
//            request.addValue(authString, forHTTPHeaderField: "Cookie")
//        }else if let headerValue = "\(credentials.username):\(credentials.password)".data(using: .utf8)?.base64EncodedString() {
//            request.addValue( "Basic " + headerValue, forHTTPHeaderField: "Authorization")
//        }
//        return request
//    }
//    func addJsonContentType() -> URLRequest {
//        var request = self
//            request.addValue( "application/json", forHTTPHeaderField: "Content-Type")
//        return request
//    }
//}

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let api = Logger(subsystem: subsystem, category: "API")
}
