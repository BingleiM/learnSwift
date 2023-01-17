import UIKit
import Foundation

enum PrinterError: Error {
    case outOfPaper
    case noToner
    case onFire
}

func send(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "Never Has Toner" {
        throw PrinterError.noToner
    }
    return "Job sent"
}

do {
    let printerResponse = try send(job: 1040, toPrinter: "Bi Sheng")
    print(printerResponse)
} catch PrinterError.onFire {
    print("I'll just put this over here, with the rest of the fire.")
} catch let printerError as PrinterError {
    print("Printer error: \(printerError).")
} catch {
    print(error)
}

// associatedtype 用来在协议中定义泛型
protocol SomeProtocol {
    associatedtype T
    func configModel(_ model: T)
}

class ClassA<ModelType>: SomeProtocol {
    typealias T = ModelType
    func configModel(_ model: ModelType) {}
}

class ClassB: ClassA<Any> {
    override func configModel(_ model: Any) {}
}

class ClassC: ClassA<String> {
    override func configModel(_ model: String) {}
}


