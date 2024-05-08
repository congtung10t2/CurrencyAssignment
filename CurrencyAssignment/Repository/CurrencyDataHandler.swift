//
//  CurrencyDataHandler.swift
//  CurrencyAssignment
//
//  Created by tungdev on 24/4/24.
//

import Foundation
class CurrencyDataHandler: CurrencyFetching {
    private let localRepository: LocalRepository
    private let remoteRepository: RemoteRepository

    init(localRepository: LocalRepository, remoteRepository: RemoteRepository) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
    }

    func fetchExchangeRate(baseCurrency: String, completion: @escaping (Result<Currency, Error>) -> Void) {
        localRepository.fetchExchangeRate(baseCurrency: baseCurrency) { [weak self] result in
            switch result {
            case .success(let currency):
                completion(.success(currency))
            case .failure:
                // If the cache fails or is empty, fetch from remote repository
                self?.remoteRepository.fetchExchangeRate(baseCurrency: baseCurrency) { remoteResult in
                    switch remoteResult {
                    case .success(let newCurrencyData):
                        // Cache the new data locally
                        self?.localRepository.saveCurrencyData(baseCurrency: baseCurrency, currency: newCurrencyData)
                        completion(.success(newCurrencyData))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
