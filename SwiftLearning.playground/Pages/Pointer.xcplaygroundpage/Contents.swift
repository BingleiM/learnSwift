//: [Previous](@previous)

import Foundation

// MARK: -- Struct --
struct Person {
    var name: String
    var age: Int
}

var person = Person(name: "Damon", age: 18)
let personPointer = UnsafeMutablePointer(&person)
// pointee 只读, 获取指针指向的实例对象
print(personPointer.pointee) // Person(name: "Damon", age: 18)

// MARK: -- Class --
class Student: CustomStringConvertible {
    var name: String
    var age: Int
    var id: Int
    
    init(name: String, age: Int, id: Int) {
        self.name = name
        self.age = age
        self.id = id
    }
    
    var description: String {
        return "\(Self.self)(name: \(name), age: \(age), id: \(id))"
    }
}

var stu = Student(name: "谢大倩", age: 18, id: 1001)
let stuPointer = UnsafeMutablePointer<Student>.init(&stu)
stuPointer.pointee.age = 20
print(stu)

// MARK: -- Enum --
enum RequestResult {
    case success
    case failure
}

var result = RequestResult.success
let resultPointer = UnsafeMutablePointer(&result)
print(resultPointer.pointee)

// MARK: -- 泛型 --
struct Animal<T> {
    var rawData: T
    func canMove() {
        print("\(rawData) can move!")
    }
}

var tiger = Animal(rawData: "🐯")
let tigerPointer = UnsafeMutablePointer(&tiger)
tigerPointer.pointee.canMove()

var ani = Animal(rawData: 15)
let aniPointer = UnsafeMutablePointer(&ani)
aniPointer.pointee.canMove()

// MARK: -- 获取 Struct 类型实例的指针, From HandyJSON --

typealias Byte = Int8

public protocol _Measurable {}

extension _Measurable {
    
    // 获取 Struct 类型实例的指针, From HandyJSON
    mutating func headPointerOfStruct() -> UnsafeMutablePointer<Byte> {
        return withUnsafeMutablePointer(to: &self) {
            return UnsafeMutableRawPointer($0).bindMemory(to: Byte.self, capacity: MemoryLayout<Self>.stride)
        }
    }
    
    // 获取 Class 类型实例的指针, From HandyJSON
    func headPointerOfClass() -> UnsafeMutablePointer<Int8> {
        let opaquePointer = Unmanaged.passUnretained(self as AnyObject).toOpaque()
        let mutableTypedPointer = opaquePointer.bindMemory(to: Int8.self, capacity: MemoryLayout<Self>.stride)
        return UnsafeMutablePointer<Int8>(mutableTypedPointer)
    }
}

// MARK: -- Self self --
// .self 可以用在类型后面获取类型本身, 也可以用在实例后面取得这个实例本身
/*
class A {
    class func method() {
        print("hello")
    }
    
    func objMethod() {
        print("world")
    }
}

A.method()
A.self.method()

let anyClass: AnyClass = A.self
(anyClass as! A.Type).method()
 */

// 在定义协议的时候 Self 用的频率很高, Self 不仅指代的是实现该协议的类型本身, 也包括了这个类型的子类
protocol MProtocol {
    
    // 协议定义一个方法, 接受实现该协议的自身类型并返回一个同样的类型
    func testMethod(c: Self) -> Self
    
    // 不能在协议中定义 泛型 进行限制
    // Self 不仅指代的是 实现该协议的类型本身, 也包括了这个类型的子类
}
let count = 4
let bytesPointer = UnsafeMutableRawPointer.allocate(
        byteCount: count * MemoryLayout<Int8>.stride,
        alignment: MemoryLayout<Int8>.alignment)
let values: [Int8] = [1, 2, 3, 4]
let int8Pointer = values.withUnsafeBufferPointer { buffer in
    return bytesPointer.initializeMemory(as: Int8.self,
              from: buffer.baseAddress!,
              count: buffer.count)
}

int8Pointer.pointee == 1
(int8Pointer + 3).pointee == 4
debugPrint((int8Pointer + 1).pointee)
// After using 'int8Pointer':
//int8Pointer.deallocate()
