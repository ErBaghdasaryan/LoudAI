//
//  PaymentViewModel.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 17.03.25.
//
import Foundation
import LoudAIModel

public protocol IPaymentViewModel {

}

public class PaymentViewModel: IPaymentViewModel {

    private let paymentService: IPaymentService

    public init(paymentService: IPaymentService) {
        self.paymentService = paymentService
    }
}
