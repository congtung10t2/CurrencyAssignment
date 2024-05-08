//
//  LocalCurrency.swift
//  CurrencyAssignment
//
//  Created by tungdev on 24/4/24.
//

import Foundation

protocol LocalRepository: CurrencyFetching {
    func saveCurrencyData(baseCurrency: String, currency: Currency)
}
class LocalRepositoryImplement: LocalRepository {
    private let defaults = UserDefaults.standard
    private let cacheKeyPrefix = "currencyData-"
    private let timestampKeySuffix = "-timestamp"

    func fetchExchangeRate(baseCurrency: String, completion: @escaping (Result<Currency, Error>) -> Void) {
        let key = cacheKeyPrefix + baseCurrency
        let timestampKey = key + timestampKeySuffix
        
        // Check if the cache contains valid, up-to-date data
        if let timestamp = defaults.object(forKey: timestampKey) as? Date,
           let data = defaults.data(forKey: key),
           let currency = try? JSONDecoder().decode(Currency.self, from: data),
           Calendar.current.isDateInToday(timestamp) {
            completion(.success(currency))
        } else {
            // Either data is not found, or it is outdated
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No valid cache data found or data is outdated"])))
        }
    }

    func saveCurrencyData(baseCurrency: String, currency: Currency) {
        let key = cacheKeyPrefix + baseCurrency
        let timestampKey = key + timestampKeySuffix
        // Remove outdated cache before saving new data
        removePreviousCache(baseCurrency: baseCurrency)
        
        if let data = try? JSONEncoder().encode(currency) {
            defaults.set(data, forKey: key)
            defaults.set(Date(), forKey: timestampKey)
        }
    }

    // Function to remove previous cache
    private func removePreviousCache(baseCurrency: String) {
        let key = cacheKeyPrefix + baseCurrency
        let timestampKey = key + timestampKeySuffix
        defaults.removeObject(forKey: key)
        defaults.removeObject(forKey: timestampKey)
    }
}
