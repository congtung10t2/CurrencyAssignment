//
//  CurrencyState.swift
//  CurrencyAssignment
//
//  Created by tungdev on 24/4/24.
//

import Foundation

struct CurrencyState {
    var inputAmount: String = "100"
    var baseCurrency: String = "USD"
    var targetCurrency: String = "EUR"
    var exchangeRate: Decimal?
    var isLoading: Bool = false
    var errorMessage: String?
    var outputAmount: String = ""
}
