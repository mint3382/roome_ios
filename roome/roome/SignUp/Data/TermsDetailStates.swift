//
//  TermsDetailStates.swift
//  roome
//
//  Created by minsong kim on 6/18/24.
//

import Foundation

enum TermsDetailStates {
    case service
    case personal
    case advertise
    
    var title: String {
        switch self {
        case .service:
            "서비스 이용약관"
        case .personal:
            "개인정보처리방침"
        case .advertise:
            "광고성 정보 수신 및 마케팅 활용"
        }
    }
    
    var link: String  {
        switch self {
        case .service:
            "https://marchens.notion.site/9210c54b3ec34a799a6d605f0f605698?pvs=4"
        case .personal:
            "https://marchens.notion.site/cb968cba569a404dadc50d5a3e6c79e7?pvs=4"
        case .advertise:
            "https://marchens.notion.site/00aaa66a3df4490f8d1cc519f357077b?pvs=4"
        }
    }
}
