//
//  UserContainer.swift
//  roome
//
//  Created by minsong kim on 5/20/24.
//

import UIKit

class UserContainer {
    static let shared = UserContainer()
    private let apiProvider = APIProvider()
    var user: UserDTO?
    var userImage: UIImage = UIImage(resource: .userProfile).resize(newWidth: 80)
    var profile: ProfileDTO?
    var defaultProfile: ProfileDefaultDTO?
    
    private init() {}
    
    func resetUser() {
        user = nil
        profile = nil
        userImage = UIImage(resource: .userProfile).resize(newWidth: 80)
    }
    
    func updateUserInformation() async throws {
        let userURL = URLBuilder(host: APIConstants.roomeHost,
                                 path: APIConstants.User.users.name,
                                 queries: nil)
        guard let url = userURL.url else {
            throw TypeError.bindingFailure
        }
        
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        let requestBuilder = RequestBuilder(url: url, method: .get, headers: header)
        guard let request = requestBuilder.create() else {
            throw TypeError.bindingFailure
        }
        
        user = try await apiProvider.fetchDecodedData(type: UserDTO.self, from: request)
        try await updateUserImage(user?.data.imageUrl ?? "")
    }
    
    func updateUserProfile() async throws {
        let userURL = URLBuilder(host: APIConstants.roomeHost,
                                 path: APIConstants.Profile.profiles.rawValue,
                                 queries: nil)
        guard let url = userURL.url else {
            throw TypeError.bindingFailure
        }
        
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        let requestBuilder = RequestBuilder(url: url, method: .get, headers: header)
        guard let request = requestBuilder.create() else {
            throw TypeError.bindingFailure
        }
        
        profile = try await apiProvider.fetchDecodedData(type: ProfileDTO.self, from: request)
    }
    
    func deleteUserProfile() async throws {
        let userURL = URLBuilder(host: APIConstants.roomeHost,
                                 path: APIConstants.Profile.profiles.rawValue,
                                 queries: nil)
        guard let url = userURL.url else {
            throw TypeError.bindingFailure
        }
        
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        let requestBuilder = RequestBuilder(url: url, method: .delete, headers: header)
        guard let request = requestBuilder.create() else {
            throw TypeError.bindingFailure
        }
        
        profile = nil
        _ = try await APIProvider().fetchData(from: request)
    }
    
    func updateDefaultProfile() async throws {
        let userURL = URLBuilder(host: APIConstants.roomeHost,
                                 path: APIConstants.Profile.defaults.rawValue,
                                 queries: nil)
        guard let url = userURL.url else {
            throw TypeError.bindingFailure
        }
        
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        let requestBuilder = RequestBuilder(url: url, method: .get, headers: header)
        guard let request = requestBuilder.create() else {
            throw TypeError.bindingFailure
        }
        
        defaultProfile = try await apiProvider.fetchDecodedData(type: ProfileDefaultDTO.self, from: request)
    }
    
    private func updateUserImage(_ imageURL: String) async throws {
        let url = URL(string: imageURL)
        
        guard let url else {
            userImage = UIImage(resource: .userProfile).resize(newWidth: 80)
            return
        }
        
        let data = try await apiProvider.fetchURLData(from: url)
        
        userImage = UIImage(data: data) ?? UIImage(resource: .userProfile).resize(newWidth: 80)
    }
}
