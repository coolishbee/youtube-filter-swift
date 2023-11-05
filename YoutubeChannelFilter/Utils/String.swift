//
//  ExtensionHelpers.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/24.
//

import Foundation

extension String
{
    init?(htmlEncodedString: String) {
        
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
        
    }
    
    func trimming(upper count: Int) -> String {
        if let endIndex = index(startIndex, offsetBy: count, limitedBy: endIndex) {
            return String(self[startIndex..<endIndex])
        }
        return self
    }
    
    func uploadDate() -> String {
//        let indexT = self.firstIndex(of: "T")
//        let shortDate = String(self[...self.index(before: indexT!)])
//        return "Uploaded on: "+shortDate
        
        if let indexT = self.firstIndex(of: "T") {
            return "Uploaded on: " + String(self[...index(before: indexT)])
        }
        return self
    }
    
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
}
