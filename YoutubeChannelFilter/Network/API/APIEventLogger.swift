//
//  APIEventLogger.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/08/02.
//

import Alamofire

class APIEventLogger: EventMonitor {
    let queue = DispatchQueue(label: "APIEventLogger")
    
    func requestDidFinish(_ request: Request) {
        
        print((request.request?.httpMethod ?? "") +
              (" --> ") +
              (request.request?.url?.absoluteString ?? "")
        )
        print(request.request?.httpBody?.toPrettyPrintedString ?? "")
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        
        print("\(response.response?.statusCode ?? 0)" +
              (" --> ") +
              (request.request?.url?.absoluteString ?? "")
        )
        print(response.data?.toPrettyPrintedString ?? "")
    }
}

extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
