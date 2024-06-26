//
//  MyProfileViewModel.swift
//  roome
//
//  Created by minsong kim on 6/19/24.
//

import Combine
import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon
import UIKit

class MyProfileViewModel {
    struct Input {
        let tappedShareButton = PassthroughSubject<Void, Never>()
    }
    
    let input: Input
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        self.input = Input()
        settingBind()
    }
    
    private func settingBind() {
        input.tappedShareButton
            .sink { [weak self] in
                self?.updateImageToKakaoServer()
            }
            .store(in: &cancellables)
    }
    
    private func updateImageToKakaoServer() {
        let image = ImageManager.loadImageFromDirectory(identifier: .squareCard)
        
        if let profileImage = image {
            ShareApi.shared.imageUpload(image: profileImage) { (imageUploadResult, error ) in
                if let error = error {
                    print(error)
                }
                else {
                    print("🔥🔥🔥🔥🔥")
                    print("imageUpload() success.")
                    let url = imageUploadResult?.infos.original.url
                    self.useCustomTemplate(imageURL: url)
                }
            }
        }
    }
    
    private func useCustomTemplate(imageURL: URL?) {
        if ShareApi.isKakaoTalkSharingAvailable() {
            guard let name = UserContainer.shared.user?.data.nickname else {
                return
            }
            // 카카오톡으로 카카오톡 공유 가능
            ShareApi.shared.shareCustom(templateId: 109406, templateArgs:["PROFILE_IMAGE": imageURL?.absoluteString ?? "", "NICK":name]) {(sharingResult, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("shareCustom() success.")
                    if let sharingResult = sharingResult {
                        UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                    }
                }
            }
        } else {
            //TODO: - 카카오톡 미설치, 알림창 띄우기
        }
    }
}
