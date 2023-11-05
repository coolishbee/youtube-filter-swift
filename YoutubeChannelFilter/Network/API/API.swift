//
//  APIClient.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/08/02.
//

import Foundation
import Alamofire

public enum API {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
    
    @discardableResult
    private static func performRequest<T:Decodable>(
        _ route:APIRouter,
        decoder: JSONDecoder = JSONDecoder(),
        _ completion:@escaping (Result<T, AFError>)->Void
    ) -> DataRequest
    {
        return session.request(route).responseDecodable(decoder: decoder) {
            (response: DataResponse<T, AFError>) in completion(response.result)
        }
    }
    
    static func youtubeSearch(searchWord: String,
                              completion:@escaping (Result<RespSearch, AFError>)->Void) {
        performRequest(APIRouter.youtubeSearch(query: searchWord), completion)
    }
    
}
