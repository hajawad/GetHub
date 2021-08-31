//
//  APIService.swift
//  GetHub
//
//  Created by Hashim Ahmed on 21/01/1443 AH.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

struct Resource<T: Codable> {
    let url: URL
}

class APIService {
    func load<T>(resource: Resource<T>, completionHandler: @escaping (T) -> Void) {
        var request = URLRequest(url: resource.url)
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
          if let error = error {
            fatalError(error.localizedDescription)
          }
            
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            fatalError("Error with the response, unexpected status code: \(String(describing: response))")
          }

          if let data = data {
            let result = try? JSONDecoder().decode(T.self, from: data)
            completionHandler(result!)
          }
        }).resume()
    }
    
    func load<T>(resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url).flatMap { url -> Observable<Data> in
            var request = URLRequest(url: url)
            request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
            return URLSession.shared.rx.data(request: request)
        }.map { data -> T in
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}
