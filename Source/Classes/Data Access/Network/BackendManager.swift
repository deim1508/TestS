//
//  BackendManager.swift
//  events
//
//  Created by halcyon on 12/13/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import Alamofire
import Foundation

class BackendManager {
    static func execute<T: Decodable> (request: RequestRepresentable, succes: @escaping ([T]) -> Void, failure: @escaping (Error) -> Void ) {
        self.performRequest(request: request, completion: { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else { failure(BackendError.invalidData); return }
                    let returnValue = try JSONDecoder().decode([T].self, from: data)
                    succes(returnValue)
                } catch {
                    failure(BackendError.invalidJSON)
                }
            case .failure:
                failure(response.error ?? BackendError.generalError)
            }})
    }

    static func execute<T: Decodable> (request: RequestRepresentable, succes: @escaping (T) -> Void, failure: @escaping (Error) -> Void ) {
        self.performRequest(request: request, completion: { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else { failure(BackendError.invalidData); return }
                    let returnValue = try JSONDecoder().decode(T.self, from: data)
                    succes(returnValue)
                } catch {
                    failure(BackendError.invalidJSON)
                }
            case .failure:
                failure(response.error ?? BackendError.generalError)
            }})
    }

    private static func performRequest(request: RequestRepresentable, completion: @escaping (DataResponse<Data>) -> Void) {
        do {
            let dataRequest = try self.buildRequest(request: request)
            dataRequest
                .validate()
                .responseData { response in
                    completion(response)
            }
        } catch {
            return
        }
    }

    private static func buildHeader() -> HTTPHeaders {
        var headers: HTTPHeaders {
            let header = [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
//            if let token = KeychainManager.shared.token {
//                header[HTTPHeaderField.authentication.rawValue] = token
//            }
            return header
        }
        return headers
    }

    private static func buildRequest(request: RequestRepresentable) throws -> DataRequest {
        let url = try NetworkConstans.ProductionServer.authBaseURL
            .asURL()
            .appendingPathComponent(request.suffix)

        return Alamofire.request(url, method: request.methodType, parameters: request.parameters, encoding: request.encoding, headers: buildHeader())
    }
}

