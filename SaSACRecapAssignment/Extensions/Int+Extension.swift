//
//  Int+Extension.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/20/24.
//

import Foundation

extension Int {
    var putCommaEveryThreeDigits: String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
       return numberFormatter.string(for: self)!
    }
}
