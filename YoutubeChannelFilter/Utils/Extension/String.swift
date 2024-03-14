//
//  ExtensionHelpers.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/24.
//

import UIKit

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
    
    func generateImage(pointSize: CGFloat = 30) -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize,
                                                 weight: .regular,
                                                 scale: .medium)
        let image = UIImage(systemName: self,
                            withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        return image ?? UIImage()
    }
}
