//
//  String+Extension.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 5/28/24.
//

import Foundation

extension String {
    var htmlTagEraser: String {
        guard let data = self.data(using: .utf8) else { return self }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributed = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributed.string
        } catch {
            return self
        }
    }
}
