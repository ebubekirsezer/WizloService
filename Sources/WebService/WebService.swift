
import Foundation
import Alamofire

public class WebService {
    
    public static let shared = WebService()

    public var person = "Ebubekir"
    
    public func request<T: Codable>(baseURL: String, requestRoute: WebRouter, responseModel: T.Type, completion: @escaping(Result<T, WebServiceError>) -> Void) {
        
        Constants.kWizloServiceBaseURL = baseURL + "api/"
        
        do {
            let urlRequest = try requestRoute.asURLRequest()
            
            AF.request(urlRequest).validate().responseJSON { (response) in
                
                switch response.result {
                case .success(let result):

                    do {
                        // JSON
                        if let resultValue = result as? [String: Any] {
                            let jsonData = try JSONSerialization.data(withJSONObject: resultValue, options: .prettyPrinted)
                            let jsonResults = try JSONDecoder().decode(responseModel, from: jsonData)
                            completion(.success(jsonResults))
                        }
                        // Array of JSON
                        if let resultValue = result as? [[String: Any]] {
                            let jsonData = try JSONSerialization.data(withJSONObject: resultValue, options: .prettyPrinted)
                            let jsonResults = try JSONDecoder().decode(responseModel, from: jsonData)
                            completion(.success(jsonResults))
                        }
                    } catch {
                        completion(.failure(.parseError))
                    }
                case .failure(let error):
                    print(error)
                    completion(.failure(.badRequestError))
                }
            }
        } catch {
            completion(.failure(.badURLError))
        }
    }
}
