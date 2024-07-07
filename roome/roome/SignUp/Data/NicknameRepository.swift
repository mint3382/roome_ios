//
//  NicknameRepository.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import UIKit

class NicknameRepository: NicknameRepositoryType {
    func requestNickname(_ name: String) async throws {
        
        let nicknameURL = URLBuilder(host: APIConstants.roomeHost,
                                     path: APIConstants.User.nickname.name,
                                     queries: nil)
        guard let url = nicknameURL.url else {
            throw TypeError.bindingFailure
        }
        
        
        let body: [String: Any] = ["nickname": name]
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        
        let requestBuilder = RequestBuilder(url: url, 
                                            method: .put,
                                            bodyJSON: body,
                                            headers: header)
        guard let request = requestBuilder.create() else {
            throw  TypeError.bindingFailure
        }
        
        _ = try await APIProvider().fetchData(from: request)
    }
    
    //멀티파트 이미지 업로드
//    func requestImage(_ image: UIImage) async throws {
//        let imageURL = URLBuilder(host: APIConstants.roomeHost,
//                                     path: APIConstants.User.image.name,
//                                     queries: nil)
//        guard let url = imageURL.url,
//              let imageData = image.pngData() else {
//            throw TypeError.bindingFailure
//        }
//        
//        let boundary = UUID().uuidString
//        let accessToken = KeyChain.read(key: .accessToken) ?? ""
//        let header = ["Content-Type": "multipart/form-data; boundary=\(boundary)",
//                      "Authorization": "Bearer \(accessToken)"]
//        
//        var body = Data()
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
//        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//        body.append(imageData)
//        body.append("\r\n".data(using: .utf8)!)
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        
//        let requestBuilder = RequestBuilder(url: url,
//                                            method: .post,
//                                            bodyData: body,
//                                            headers: header)
//        guard let request = requestBuilder.create() else {
//            throw  TypeError.bindingFailure
//        }
//        
//        _ = try await APIProvider().fetchData(from: request)
//    }
//    
//    func requestImageDelete() async throws {
//        let imageURL = URLBuilder(host: APIConstants.roomeHost,
//                                     path: APIConstants.User.image.name,
//                                     queries: nil)
//        guard let url = imageURL.url else {
//            throw TypeError.bindingFailure
//        }
//        
//        let accessToken = KeyChain.read(key: .accessToken) ?? ""
//        let header = ["Content-Type": "application/json",
//                      "Authorization": "Bearer \(accessToken)"]
//        
//        let requestBuilder = RequestBuilder(url: url,
//                                            method: .delete,
//                                            headers: header)
//        
//        guard let request = requestBuilder.create() else {
//            throw  TypeError.bindingFailure
//        }
//        
//        _ = try await APIProvider().fetchData(from: request)
//    }
}
