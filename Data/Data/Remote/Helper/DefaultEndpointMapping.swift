//
//  DefaultEndpointMapping.swift
//  Data
//
//  Created by Thanh Quang on 14/10/2022.
//

import Moya

class DefaultEndpointMapping: NetworkConfigurable {
    func endpointsClosure<T>() -> (_ target: T) -> Endpoint where T: TargetType {
        return { target in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            let additionalParameters = ["api_key": self.apiKey]
            let defaultEncoding = URLEncoding.default
            let task: Task
            
            switch target.task {
            case .requestPlain:
                task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
            case let .requestData(data):
                task = .requestCompositeData(bodyData: data, urlParameters: additionalParameters)
            case let .requestJSONEncodable(encodable):
                // You would have to create data from `encodable`, encode it to JSON object, then append parameters
                // and make Data from it - and assign .requestData to the task
                task = target.task
            case .requestCustomJSONEncodable(let encodable, encoder: let encoder):
                // You would have to create data from `encodable`, encode it to JSON object, then append parameters
                // and make Data from it - and assign .requestData to the task
                task = target.task
            case .requestParameters(var parameters, let encoding):
                additionalParameters.forEach { parameters[$0.key] = $0.value }
                task = .requestParameters(parameters: parameters, encoding: encoding)
            case .requestCompositeData(let bodyData, var urlParameters):
                // Second decision: encode data and append the parameters there or append parameters to urlParameters?
                additionalParameters.forEach { urlParameters[$0.key] = $0.value }
                task = .requestCompositeData(bodyData: bodyData, urlParameters: urlParameters)
            case .requestCompositeParameters(let bodyParameters, let bodyEncoding, var urlParameters):
                // Third decision: where to append parameters here, body or url?
                additionalParameters.forEach { urlParameters[$0.key] = $0.value }
                task = .requestCompositeParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters)
            case let .uploadFile(url):
                // Another decision: where to add it with upload? in multipart data, or url?
                let data = Moya.MultipartFormData(provider: .file(url), name: "file")
                task = .uploadCompositeMultipart([data], urlParameters: additionalParameters)
            case let .uploadMultipart(multipartData):
                task = .uploadCompositeMultipart(multipartData, urlParameters: additionalParameters)
            case .uploadCompositeMultipart(let multipartData, var urlParameters):
                additionalParameters.forEach { urlParameters[$0.key] = $0.value }
                task = .uploadCompositeMultipart(multipartData, urlParameters: urlParameters)
            case let .downloadDestination(destination):
                // First decision: what encoding to use when there wasn't one before
                task = .downloadParameters(parameters: additionalParameters, encoding: defaultEncoding, destination: destination)
            case .downloadParameters(var parameters, let encoding, let destination):
                additionalParameters.forEach { parameters[$0.key] = $0.value }
                task = .downloadParameters(parameters: parameters, encoding: encoding, destination: destination)
            }
            
            return defaultEndpoint.replacing(task: task)
        }
    }
}
