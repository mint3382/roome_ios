//
//  UserProfileRepository.swift
//  roome
//
//  Created by minsong kim on 7/8/24.
//

import UIKit

class UserProfileRepository: UserProfileRepositoryType {
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
    func requestImage(_ image: UIImage) async throws {
        let imageURL = URLBuilder(host: APIConstants.roomeHost,
                                     path: APIConstants.User.image.name,
                                     queries: nil)
        guard let url = imageURL.url,
              let imageData = image.pngData() else {
            throw TypeError.bindingFailure
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "multipart/form-data; boundary=\(boundary)",
                      "Authorization": "Bearer \(accessToken)"]

        let httpBody = NSMutableData()
        httpBody.append(convertData(field: "file", name: "image.jpg", mimeType: "multipart/form-data", fileData: imageData, boundary: boundary))
        httpBody.appendString("--\(boundary)--")
        let body = httpBody as Data
        
        let requestBuilder = RequestBuilder(url: url,
                                            method: .post,
                                            bodyData: body,
                                            headers: header)
        guard let request = requestBuilder.create() else {
            throw  TypeError.bindingFailure
        }

        _ = try await APIProvider().fetchData(from: request)
    }
    
    private func convertData(field: String, name: String, mimeType: String, fileData: Data, boundary: String) -> Data {
        let data = NSMutableData()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(field)\"; filename=\"\(name)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data as Data
    }

    func requestImageDelete() async throws {
        let imageURL = URLBuilder(host: APIConstants.roomeHost,
                                     path: APIConstants.User.image.name,
                                     queries: nil)
        guard let url = imageURL.url else {
            throw TypeError.bindingFailure
        }

        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]

        let requestBuilder = RequestBuilder(url: url,
                                            method: .delete,
                                            headers: header)

        guard let request = requestBuilder.create() else {
            throw  TypeError.bindingFailure
        }

        _ = try await APIProvider().fetchData(from: request)
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
