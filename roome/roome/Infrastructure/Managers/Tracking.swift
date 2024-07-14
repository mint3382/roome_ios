//
//  Tracking.swift
//  roome
//
//  Created by minsong kim on 7/13/24.
//

import Foundation

struct Tracking {
    struct Login {
        static let loginView = "view_sign_in_page"
        static let kakaoButton = "tap_sign_up_kakao_button"
        static let appleButton = "tap_sign_up_apple_button"
    }
    
    struct ServiceTerms {
        static let termsView = "view_sign_up_terms_page"
        static let termseNextButton = "tap_terms_next_button"
        static let serviceDetail = "view_terms_page"
        static let serviceAgreeButton = "tap_terms_agree_button"
        static let personalDetail = "view_info_page"
        static let personalAgreeButton = "tap_info_agree_button"
    }
    
    struct Nickname {
        static let nicknameView = "view_nickname_page"
        static let nicknameSuccess = "input_nickname_success"
        static let nicknameFailure = "inpit_nickname_fail"
    }
    
    struct Profile {
        static let createView = "view_make_profile_page"
        static let createNextButton = "tap_make_profile_button"
        static let numberView = "view_number_page"
        static let numberNextButton = "tap_number_next_button"
        static let genreView = "view_genre_page"
        static let genreNextButton = "tap_genre_next_button"
        static let mbtiView = "view_mbti_page"
        static let mbtiNextButton = "tap_mbti_next_button"
        static let strengthView = "view_strength_page"
        static let strengthNextButton = "tap_strength_next_button"
        static let importantFactorView = "view_important_factor_page"
        static let importantFactorNextButton = "tap_important_factor_next_button"
        static let positionView = "view_position_page"
        static let hintView = "view_hint_page"
        static let deviceAndLockView = "view_device_lock_page"
        static let activityView = "view_activity_page"
        static let dislikeView = "view_dislike_factor_page"
        static let dislikeNextButton = "tap_dislike_factor_next_button"
        static let colorView = "view_background_page"
        static let downloadImageButton = "tap_save_button"
        static let moveMyProfileViewButton = "tap_move_to_profile_page_button"
    }
    
    struct MyProfile {
        static let myProfileView = "view_my_profile_page"
        static let myProfileCardButton = "tap_profile_card_button"
        static let shareKakaoButton = "tap_share_kakao_button"
    }
    
    struct Setting {
        static let settingView = "view_setting_page"
        static let withdrawalButton = "tap_exit_button"
    }
    
    struct Withdrawal {
        static let reasonView = "view_exit_reason_page"
        static let reasonNextButton = "tap_exit_reason_confirm_button"
        static let withdrawalAgreeView = "view_exit_confirm_page"
        static let withdrawalAgreeButton = "tap_exit_confirm_button"
        static let withdrawalFinalButton = "tap_exit_final_button"
    }
}
