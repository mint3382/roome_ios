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
//    case advertise
    
    var title: String {
        switch self {
        case .service:
            "서비스 이용약관"
        case .personal:
            "개인정보처리방침"
//        case .advertise:
//            "광고성 정보 수신 및 마케팅 활용"
        }
    }
    
    var link: String  {
        switch self {
        case .service:
            "https://roome7.notion.site/ROOME-ef60fcf881da4745b4858357fa48b6be"
        case .personal:
            "https://roome7.notion.site/ROOME-a06cfe5bf53f4d238c44a6f039616908?pvs=4"
//        case .advertise:
//            "https://marchens.notion.site/00aaa66a3df4490f8d1cc519f357077b?pvs=4"
        }
    }
}
