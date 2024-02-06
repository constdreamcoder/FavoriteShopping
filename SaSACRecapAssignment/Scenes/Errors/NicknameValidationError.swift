//
//  NicknameValidationError.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 2/6/24.
//

import UIKit

enum NicknameValidationError: Error {
    case notInBetweenTwoAndTenLetters
    case containUnallowedSpecialCharacters
    case containNumbers
    
    var errorMessage: String {
        switch self {
        case .notInBetweenTwoAndTenLetters:
            return "2글자 이상 10글자 미만으로 설정해주세요"
        case .containUnallowedSpecialCharacters:
            return "닉네임에 @, #, $, %는 포함할 수 없어요"
        case .containNumbers:
            return "닉네임에 숫자는 포함할 수 없어요"
        }
    }
    
    var errorMessageTextColor: UIColor {
        return .red
    }
}
