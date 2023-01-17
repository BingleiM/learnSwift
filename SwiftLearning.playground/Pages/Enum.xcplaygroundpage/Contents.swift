//: [Previous](@previous)

import Foundation

// MARK: -- 遍历枚举情况（case） --
/*
 对于某些枚举来说，如果能有一个集合包含了枚举的所有情况就好了。你可以通过在枚举名字后面写 : CaseIterable 来允许枚举被遍历。Swift 会暴露一个包含对应枚举类型所有情况的集合名为 allCases 。下面是例子：
 */

enum Beverage: CaseIterable {
    case coffee, tea, juice
}

let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverages available")

for beverage in Beverage.allCases {
    print(beverage)
}


// MARK: -- 递归枚举 --
/*
 枚举在对序号考虑固定数量可能性的数据建模时表现良好，比如用来做简单整数运算的运算符。这些运算符允许你组合简单的整数数学运算表达式比如5到更复杂的比如5+4.
 */
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

// 递归函数是一种操作递归结构数据的简单方法。比如说，这里有一个判断数学表达式的函数：
func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        print("")
        return evaluate(left) * evaluate(right)
    }
}

print(evaluate(product))
// Prints "18"

@propertyWrapper
struct UserDefaultWrapper<T> {
    private var storage = UserDefaults.standard
    private var defaultValue: T
    private var key: String
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
        
    var wrappedValue: T {
        get { storage.value(forKey: key) as? T ?? defaultValue }
        set(value) { storage.set(value, forKey: key) }
    }
}

protocol SomeProtocol {
    associatedtype T
    func config(_ t: T)
}

class Person<Model>: SomeProtocol {
    typealias T = String
    @UserDefaultWrapper(key: "name", defaultValue: "Damon") var name: String
    func config(_ t: String) {}
    func config(m: Model) {}
}

struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}

class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

class SubClass: SomeClass, CustomStringConvertible {
    override class var overrideableComputedTypeProperty: Int {
        set { self.overrideableComputedTypeProperty = newValue }
        get { self.overrideableComputedTypeProperty }
    }
    
    var description: String {
        return ""
    }
    
    lazy var storge = UserDefaults.standard
}

//print(SubClass.overrideableComputedTypeProperty)
//SubClass.overrideableComputedTypeProperty = 5
