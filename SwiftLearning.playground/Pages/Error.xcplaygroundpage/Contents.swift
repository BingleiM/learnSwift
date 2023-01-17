//: [Previous](@previous)

import Foundation

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

extension VendingMachineError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidSelection: return "invalidSelection"
        case .insufficientFunds(_): return "insufficientFunds"
        case .outOfStock: return "outOfStock"
        }
    }
}

let error = VendingMachineError.invalidSelection
print(error.errorDescription)

