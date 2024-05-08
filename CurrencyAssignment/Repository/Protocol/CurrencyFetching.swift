//
//  CurrencyProtocol.swift
//  CurrencyAssignment
//
//  Created by tungdev on 22/4/24.
//

import Foundation

protocol CurrencyFetching {
    func fetchExchangeRate(baseCurrency: String, completion: @escaping (Result<Currency, Error>) -> Void)
}
