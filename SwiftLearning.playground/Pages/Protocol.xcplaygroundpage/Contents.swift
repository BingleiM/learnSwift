//: [Previous](@previous)

import Foundation

protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Person: Named, Aged {
    var name: String
    var age: Int
}

// MARK: -- 协议组合 --
// 协议组合使用 SomeProtocol & AnotherProtocol 的形式。你可以列举任意数量的协议，用和符号连接（ & ），使用逗号分隔。除了协议列表，协议组合也能包含类类型，这允许你标明一个需要的父类。
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}

let birthdayPerson = Person(name: "Damon", age: 32)
wishHappyBirthday(to: birthdayPerson)

class Location {
    var latitude: Double
    var longtitude: Double
    init(latitude: Double, longtitude: Double) {
        self.latitude = latitude
        self.longtitude = longtitude
    }
}

class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longtitude: Double) {
        self.name = name
        super.init(latitude: latitude, longtitude: longtitude)
    }
}

// 函数 beginConcert(in:) 接收一个 Location & Named 类型的形式参数，也就是说任何 Location 的子类且遵循 Named 协议的类型。具体到这里， City 同时满足两者需求。
func beiginConvert(in location: Location & Named) {
    print("Hello, \(location.name)!")
}

let seattle = City(name: "Seattle", latitude: 47.6, longtitude: -122.3)
beiginConvert(in: seattle)

// MARK: -- 协议遵循的检查 --
// as 关键字
print((seattle as Named).name) // Print Seattle


// MARK: -- 可选协议要求 --
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

class ThreeSource: CounterDataSource {
    let fixedIncrement: Int = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}
// 3
// 6
// 9
// 12

class TowardsZeroSource: CounterDataSource {
    func increment(forCount count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}

counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
    counter.increment()
//    print(counter.count)
}
// -3
// -2
// -1
// 0
// 0

//enum Options: OptionSet {
//    case a = 1 << 1
//    case b = 1 << 2
//    case c = 1 << 3
//}

extension NSDecimalNumber{
    
    class func behaviors02() -> NSDecimalNumberHandler{
        return NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
    }
    
    /// 是否是整数
    func isInteger() -> Bool {
        let behavior = NSDecimalNumberHandler(roundingMode: .plain,
                                              scale: 0,
                                              raiseOnExactness: false,
                                              raiseOnOverflow: false,
                                              raiseOnUnderflow: false,
                                              raiseOnDivideByZero: false)
        return NSDecimalNumber(decimal: self.decimalValue).rounding(accordingToBehavior: behavior).compare(self) == .orderedSame
    }
    
    func isDivisibleByTen() -> Bool {
        guard self.isInteger() else { return false }
        return self.intValue % 10 == 0 ? true : false
    }
}

// MARK: -- Model --
// MARK: -- Model --
enum HexAmountRoundingMode: CustomStringConvertible {
    
    /// 不抹零
    case none
    /// 抹元
    case yuan
    /// 抹角
    case jiao
    /// 抹分
    case fen
    
    var description: String {
        switch self {
        case .none: return "不抹零"
        case .yuan: return "抹元"
        case .jiao: return "抹角"
        case .fen: return "抹分"
        }
    }
    
    // 抹零后的结果
    struct Result: CustomStringConvertible {
        /// 抹零前金额
        var original: NSDecimalNumber
        /// 抹零后金额
        var result: NSDecimalNumber
        /// 抹掉的金额
        var rounding: NSDecimalNumber?
        
        var description: String {
//            return "<original: \(original.stringValue), result: \(result.stringValue), rounding: \(String(describing: rounding?.stringValue))>"
            return "\(result.stringValue)"
        }
    }
    
    /// 抹零后金额计算，例如 15.41, 抹元后 10.00, 抹角后 15.00，抹分后 15.40
    /// - Parameter amount: 金额
    /// - Returns: 抹零的金额
    func round(_ amount: NSDecimalNumber) -> Result {
        guard !amount.decimalValue.isNaN,
                amount.compare(NSDecimalNumber.zero) == .orderedDescending else {
            return Result(original: amount, result: amount)
        }
        var result = NSDecimalNumber()
        switch self {
        case .none: result = amount
        case .yuan:
            // 如果订单为整数，如20，10，或者10元以下，则点击则无法抹除, 详见https://hexcloud.yuque.com/nf5b4k/ogbpq4/ugf7lo?#kQU3Y
            if amount.isDivisibleByTen() ||
                amount.compare(NSDecimalNumber(value: 10)) == .orderedAscending {
                return Result(original: amount, result: amount)
            }
            result = amount.dividing(by: 10, withBehavior: behavior(scale: 0)).multiplying(by: 10)
        case .jiao:
            result = amount.rounding(accordingToBehavior: behavior(scale: 0))
        case .fen:
            result = amount.rounding(accordingToBehavior: behavior(scale: 1))
        }
        return Result(original: amount, result: result, rounding: subtracting(amount, result))
    }
    
    private func subtracting(_ a: NSDecimalNumber, _ b: NSDecimalNumber) -> NSDecimalNumber {
        return a.subtracting(b, withBehavior: behavior(scale: 2))
    }
    
    private func behavior(roundingMode: NSDecimalNumber.RoundingMode = .down,
                                      scale: Int16) -> NSDecimalNumberHandler {
        return NSDecimalNumberHandler(roundingMode: roundingMode,
                                      scale: scale,
                                      raiseOnExactness: false,
                                      raiseOnOverflow: false,
                                      raiseOnUnderflow: false,
                                      raiseOnDivideByZero: false)
    }
}

func kScale(roundingMode: NSDecimalNumber.RoundingMode, scale: Int16) -> NSDecimalNumberHandler {
    return NSDecimalNumberHandler(roundingMode: roundingMode,
                                  scale: scale,
                                  raiseOnExactness: true,
                                  raiseOnOverflow: true,
                                  raiseOnUnderflow: true,
                                  raiseOnDivideByZero: true)
}

func kDN(_ string: String) -> NSDecimalNumber {
    return NSDecimalNumber(string: string)
}

print(NSDecimalNumber(value: 45.00).isInteger())
print(NSDecimalNumber(value: 45.00).isDivisibleByTen())

let amounts = [kDN("15.41"),
               kDN("100.00"),
               kDN("21.00"),
               kDN("0.45"),
               kDN("10"),
               kDN("9.95")]
let scale = kScale(roundingMode: .plain, scale: 2)
let moYuan = amounts.map { HexAmountRoundingMode.yuan.round($0) }
print(amounts, "抹元后: ", moYuan)
let moJiao = amounts.map { HexAmountRoundingMode.jiao.round($0) }
print(amounts, "抹角后: ", moJiao)
let moFen = amounts.map { HexAmountRoundingMode.fen.round($0) }
print(amounts, "抹分后: ", moFen)

