//
//  CurrencyIntent.swift
//  CurrencyAssignment
//
//  Created by tungdev on 23/4/24.
//
import Foundation
class CurrencyIntent: ObservableObject {
    @Published var state = CurrencyState()
    private let repositoryHandler: CurrencyDataHandler

    init(repositoryHandler: CurrencyDataHandler = CurrencyDataHandler(localRepository: LocalRepositoryImplement(),
                                                                      remoteRepository: RemoteRepositoryImplement())) {
        self.repositoryHandler = repositoryHandler
    }

    func fetchRate() {
        state.isLoading = true
        state.errorMessage = nil

        repositoryHandler.fetchExchangeRate(baseCurrency: state.baseCurrency) { [weak self] result in
            DispatchQueue.main.async {
                self?.state.isLoading = false
                self?.processFetchResult(result)
            }
        }
    }

    private func processFetchResult(_ result: Result<Currency, Error>) {
        switch result {
        case .success(let currencyData):
            updateStateWithCurrencyData(currencyData)
        case .failure(let error):
            state.errorMessage = error.localizedDescription
        }
    }

    private func updateStateWithCurrencyData(_ currencyData: Currency) {
            guard let rate = currencyData.conversionRates[state.targetCurrency], let rateDecimal = Decimal(string: "\(rate)") else {
                state.errorMessage = "Conversion rate not found for \(state.targetCurrency)"
                return
            }
            state.exchangeRate = rateDecimal
            updateOutputAmount(rateDecimal: rateDecimal)
        }

        private func updateOutputAmount(rateDecimal: Decimal) {
            guard let inputAmountDecimal = Decimal(string: state.inputAmount) else {
                return
            }
            let result = inputAmountDecimal * rateDecimal
            state.outputAmount = formatCurrency(result)
        }

        // Uses NumberFormatter to format currency amount.
        private func formatCurrency(_ amount: Decimal) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = state.targetCurrency
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 3

            return formatter.string(from: amount as NSDecimalNumber) ?? ""
        }

        func updateInputAmount(_ amount: String) {
            state.inputAmount = amount
            if let rate = state.exchangeRate, let rateDecimal = Decimal(string: "\(rate)") {
                updateOutputAmount(rateDecimal: rateDecimal)
            }
        }
    }
