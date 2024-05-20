//
//  UserRepository.swift
//  roome
//
//  Created by minsong kim on 5/20/24.
//

import Foundation

class UserRepository: UserRepositoryType {
    func userWithAPI(decodedDataType: UserDTO.Type) async -> UserDTO? {
        let userURL = URLBuilder(host: APIConstants.roomeHost,
                                 path: APIConstants.UserPath.users.name,
                                 queries: nil)
        guard let url = userURL.url else {
            return nil
        }
        
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        let requestBuilder = RequestBuilder(url: url, method: .get, headers: header)
        guard let request = requestBuilder.create() else {
            return nil
        }
        
        do {
            let user = try await APIProvider().fetchDecodedData(type: decodedDataType.self, from: request)
            print("유저 접근 성공")
            print(user)
            return user
        } catch NetworkError.invalidStatus(401) {
            print("토큰 재발급 필요")
        } catch {
            print(error)
        }
        
        return nil
    }
    
//    func checkUserState() async -> String {
//        let result = await Task {
//            let user = await userWithAPI(decodedDataType: UserDTO.self)
//            
//            return user?.data.state
//        }.result
//        
//        do {
//            let statue = try result.get()
//            return statue ?? ""
//        } catch {
//            print("error")
//        }
//        return ""
//    }
    
}
