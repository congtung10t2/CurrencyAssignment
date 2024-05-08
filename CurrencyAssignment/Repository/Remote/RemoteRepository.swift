//
//  CurrencyApi.swift
//  CurrencyAssignment
//
//  Created by tungdev on 24/4/24.
//

import Foundation
protocol RemoteRepository: CurrencyFetching {
    
}
struct RemoteRepositoryImplement: RemoteRepository {
    private let apiKey = "eeab3680fedc525677acf145"
    private let baseUrl = "https://v6.exchangerate-api.com/v6/"

    func fetchExchangeRate(baseCurrency: String, completion: @escaping (Result<Currency, Error>) -> Void) {
        let urlString = "\(baseUrl)\(apiKey)/latest/\(baseCurrency)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network request failed"])))
                return
            }

            do {
                let currencyData = try JSONDecoder().decode(Currency.self, from: data)
                completion(.success(currencyData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
