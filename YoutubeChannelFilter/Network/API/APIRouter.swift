//
//  APIRouter.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/08/02.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    case youtubeSearch(query: String)
    
    private var method: HTTPMethod {
        switch self {
        case .youtubeSearch:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .youtubeSearch(let query):
            return String(format: "/youtube/v3/search?key=%@&maxResults=15&part=snippet&q=%@",
                          APIConfiguration.shared.youtubeAPIKey,
                          query)
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .youtubeSearch:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let strUrl = String(format: "%@%@", Constants.DevServer.baseURL, path)
        let encodedString = strUrl.encodeUrl()!
        //print(encodedString)
        let url = try encodedString.asURL()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.setValue(ContentType.json.rawValue,
                            forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
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
