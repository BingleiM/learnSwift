//: [Previous](@previous)

import Foundation

let greeting = "Hello, playground"
greeting[greeting.startIndex]
greeting[greeting.index(before: greeting.endIndex)]
greeting[greeting.index(after: greeting.startIndex)]
let index = greeting.index(greeting.startIndex, offsetBy: 7)
greeting[..<greeting.endIndex]

for index in greeting.indices {
    print("\(greeting[index])", terminator: " ")
}
print("")

func test(_ argus: UnsafePointer<Int>...) {
    for argu in argus {
        print(argu)
    }
}

/// 闭包的值捕获
///  逃逸闭包必须显式捕获变量, 非逃逸闭包会自动隐式捕获变量
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementerByTen = makeIncrementer(forIncrement: 10)
incrementerByTen()

var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

struct SomeStruct {
    var x = 10
    mutating func doSomething() {
        someFunctionWithNonescapingClosure { x = 200 }  // Ok
//        someFunctionWithEscapingClosure { x = 100 }     // Error
    }
}

var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}

//serve { customersInLine.remove(at: 0) }
//serve(customer: { customersInLine.remove(at: 0) })
