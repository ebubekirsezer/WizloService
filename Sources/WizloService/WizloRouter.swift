//
//  File.swift
//  
//
//  Created by Ebubekir Sezer on 5.08.2021.
//

import Foundation
import Alamofire

public enum WizloRouter: URLRequestConvertible {
    case login(token: String, body: Parameters?, language: String)
    case getFAQ(token: String, language: String)
    case getAboutUs(token: String, language: String)
    
    public var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getFAQ:
            return .get
        case .getAboutUs:
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
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try Constants.kWizloServiceBaseURL.asURL()
        
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
        
        return urlRequest
    }
}
