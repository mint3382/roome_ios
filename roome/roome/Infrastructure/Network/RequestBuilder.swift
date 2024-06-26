//
//  RequestBuilder.swift
//  roome
//
//  Created by minsong kim on 5/13/24.
//

import Foundation

struct RequestBuilder {
    private let url: URL
    private let method: HTTPMethod
    private let bodyJSON: [String: Any]?
    private let bodyData: Data?
    private let headers: [String: String]

    init(url: URL,
         method: HTTPMethod,
         bodyJSON: [String: Any]? = nil,
         bodyData: Data? = nil,
         headers: [String: String] = ["Content-Type": "application/json"]) {

        self.url = url
        self.method = method
        self.bodyJSON = bodyJSON
        self.bodyData = bodyData
        self.headers = headers
    }

    func create() -> URLRequest? {
        var request = URLRequest(url: url)
        
        if let bodyJSON {
            request.httpBody = makeRequestJSONBody(with: bodyJSON)
        } else if let bodyData {
            request.httpBody = bodyData
        }
        
        request.httpMethod = method.typeName
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    private func makeRequestJSONBody(with json: [String: Any]) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        return jsonData
    }
//    
//    private func makeRequestDataBody(with data: [String: Any]) -> Data? {
//        let body = NSMutableData()
//        guard let boundary = data["boundary"],
//              let imageData = data["imageData"] as? Data,
//              let mimeType = data["mimeType"],
//              let filename = data["filename"] else {
//            return nil
//        }
//        let imageKey = "img"
//        let boundaryPrefix = "--\(boundary)\r\n"
//        
//        guard let boundaryPrefixString = boundaryPrefix.data(using: String.Encoding.utf8, allowLossyConversion: false),
//              let contentDisposition = "Content-Disposition: form-data; name=\"\(imageKey)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false),
//                let contentType = "Content-Type: \(mimeType)\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)
//                 else {
//            return nil
//        }
//        
//        body.append(boundaryPrefixString)
//        body.append(contentDisposition)
//        body.append(contentType)
//        body.append(imageData)
//        body.appendString("\r\n")
//        body.appendString("-".appending(boundary.appending("—")))
//
//        
//        return nil
//    }
}
//
//extension NSMutableData {
//    func appendString(_ string: String) {
//        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
//        append(data!)
//    }
//}
