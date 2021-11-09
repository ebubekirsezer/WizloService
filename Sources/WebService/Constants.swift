//
//  File.swift
//  
//
//  Created by Ebubekir Sezer on 5.08.2021.
//

import Foundation

struct Constants {
    static var kWizloServiceBaseURL = "https://yemekbana.azurewebsites.net/api/"
    static let kWizloServiceLogin = "user/login"
    static let kWizloServiceFAQs = "menu-and-operation/misc-content/faq"
    static let kWizloServiceAboutUs =  "menu-and-operation/misc-content/about-us"
    static let person = "Ebubekirs"
    
    static let kMovieDBBaseURL = "https://api.themoviedb.org/"
    
}

//The header fields
enum HttpHeaderField: String {
    case contentType = "Content-Type"
    case acceptLanguage = "Accept-Language"
    case accept = "Accept"
    case platform = "Platform"
    case authorization = "Authorization"
}

//The content type (JSON)
enum ContentType: String {
    case json = "application/json"
    case ios = "IOS"
}
