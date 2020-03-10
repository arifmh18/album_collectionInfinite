//
//  DataNetwork.swift
//  Album Kenangan
//
//  Created by Muhammad Arif Hidayatulloh on 09/03/20.
//  Copyright © 2020 ENGINEERING TEST. All rights reserved.
//

import Foundation
import Moya

enum DataNetwork {
    case province
    case city(province:String)
    case cost(origin:String, destination: String, weight: String, courier: String)
    case albums(page:Int)
    case photo(page:Int)
}

private var key = "odagDblZjxAwJmlEQe68V6JtTQdXKWp2NRXe"
private var base_url = "https://gorest.co.in"

extension DataNetwork : TargetType {
    var baseURL: URL {
        return URL(string: base_url)!
    }
    
    var path: String {
        switch self {
        case .albums:
            return "/public-api/albums"
        case .photo:
            return "/public-api/photos"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .albums(let page):
            return "{\"_format\": json, access-token\": \"\(key)\", page\": \"\(page)\"}".utf8Encoded
        case .photo(let page):
            return "{\"_format\": json, access-token\": \"\(key)\", page\": \"\(page)\"}".utf8Encoded
        default:
            return "".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case let .city(province):
            return .requestParameters(parameters: ["province":province], encoding: URLEncoding.queryString)
        case let .cost(origin, destination, weight, courier):
            return .requestParameters(parameters: ["origin":origin, "destination":destination, "weight":weight, "courier":courier], encoding: URLEncoding.queryString)
        case let .albums(page):
            return .requestParameters(parameters: ["_format":"json","access-token":key, "page":page], encoding: URLEncoding.queryString)
        case let .photo(page):
            return .requestParameters(parameters: ["_format":"json","access-token":key, "page":page], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var httpHeaders: [String: String] = [:]
        httpHeaders["Key"] = key
        return httpHeaders

    }
    
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}


