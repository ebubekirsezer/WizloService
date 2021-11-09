//
//  File.swift
//  
//
//  Created by Ebubekir Sezer on 5.08.2021.
//

import Foundation
import Alamofire

public enum WebRouter: URLRequestConvertible {
    case login(token: String, body: Parameters?, language: String)
    case getFAQ(token: String, language: String)
    case getAboutUs(token: String, language: String)
    
    case getMovie
    
    public var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getFAQ:
            return .get
        case .getAboutUs:
            return .get
        case .getMovie:
            return .get
        }
    }
    
    public var path: String {
        switch self {
        case .login:
            return Constants.kWizloServiceLogin
        case .getFAQ:
            return Constants.kWizloServiceFAQs
        case .getAboutUs:
            return Constants.kWizloServiceAboutUs
        case .getMovie:
            return Constants.kMovieDBBaseURL2
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .login(_, let body, _):
            return body
        case .getFAQ:
            return nil
        case .getAboutUs:
            return nil
        case .getMovie:
            return nil
        }
    }
    
    public var token: String {
        switch self {
        case .getFAQ(let token, _), .login(let token, _, _), .getAboutUs(let token, _):
            return token
        default:
            return ""
        }
    }
    
    public var language: String {
        switch self {
        case .getFAQ(_, let language), .login(_, _, let language), .getAboutUs(_, let language):
            return language
        default:
            return ""
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try Constants.kMovieDBBaseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HttpHeaderField.contentType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HttpHeaderField.accept.rawValue)
        urlRequest.setValue(ContentType.ios.rawValue, forHTTPHeaderField: HttpHeaderField.platform.rawValue)
        urlRequest.setValue(self.token, forHTTPHeaderField: HttpHeaderField.authorization.rawValue)
        urlRequest.setValue(self.language, forHTTPHeaderField: HttpHeaderField.acceptLanguage.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        let parameters: Parameters = [
                "api_key": "d9c7288fbcbc30ac0f4571f622448ef6"
                ]
        
        
        
        return urlRequest
    }
}
