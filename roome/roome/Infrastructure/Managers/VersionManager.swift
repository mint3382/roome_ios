//
//  VersionManager.swift
//  roome
//
//  Created by minsong kim on 7/25/24.
//

import Foundation

class VersionManager {
    static var currentVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else {
            return nil
        }
        
        return version
    }
    
    static var latestVersion: String? {
        let appleID = "6503616766"
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let resultCount = json["resultCount"] as? Int,
              resultCount != 0,
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
        
        return appStoreVersion
    }
    
    class func requestLeastVersion() async -> String? {
        let versionURL = URLBuilder(host: APIConstants.roomeHost, path: APIConstants.Version.iOS.rawValue, queries: nil)
        guard let url = versionURL.url else {
            return nil
        }
        
        let requestBuilder = RequestBuilder(url: url, method: .get)
        guard let request = requestBuilder.create() else {
            return nil
        }

        do {
            let version = try await APIProvider().fetchDecodedData(type: VersionDTO.self, from: request)
            print("version: \(version.data.version)")
            return version.data.version
        } catch {
            print(error)
        }
        
        return nil
    }
    
//    class func checkUpdate() async {
//        let leastVersion = reque
//    }
}

struct VersionDTO: Decodable {
    let code: Int
    let message: String
    let data: Version

    struct Version: Codable {
        let version: String
    }
}
