//
//  ContentView.swift
//  CurrencyAssignment
//
//  Created by tungdev on 22/4/24.
//

import SwiftUI

struct CurrencyConverterView: View {
    @ObservedObject var intent = CurrencyIntent()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Currency Converter")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if intent.state.isLoading {
                ProgressView()
            } else if let rate = intent.state.exchangeRate {
                Text("Exchange Rate: \(rate.formatted())")
                    .font(.title2)
            }
            
            VStack {
                Text("Base Currency")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                HStack {
                    TextField("Enter base currency (e.g., USD)", text: $intent.state.baseCurrency)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .frame(width: 150)
                    TextField("Input", text: $intent.state.inputAmount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                }
                
            }
            
            VStack {
                Text("Target Currency")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                HStack {
                    TextField("Enter target currency (e.g., EUR)", text: $intent.state.targetCurrency)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .textInputAutocapitalization(.characters)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .frame(width: 150)
                    TextField("Result", text: $intent.state.outputAmount)
                        .disabled(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .textInputAutocapitalization(.characters)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                    
                }
            }
            
            if let errorMessage = intent.state.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            Button(action: {
                intent.fetchRate()
            }, label: {
                Text("Exchanging")
                    .bold()
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 24)
                    .padding([.top, .bottom], 16)
                
            })
            .background(Color.blue)
            .cornerRadius(24)
        }
        .onAppear() {
            intent.fetchRate()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
    
}

#Preview {
    CurrencyConverterView()
}
