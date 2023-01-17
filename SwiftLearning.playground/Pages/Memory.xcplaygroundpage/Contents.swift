import Foundation

/*
unsafePointer unsafePointer<T> 等同于 const T *.
unsafeMutablePointer unsafeMutablePointer<T> 等同于 T *
unsafeRawPointer unsafeRawPointer 等同于 const void *
unsafeMutableRawPointer unsafeMutableRawPointer 等同于 void *
*/
 
// MARK: -- 操作内存修改一个 Struct 类型实例的属性的值 --
enum Kind {
    case wolf, fox, dog, sheep
}

// MARK: -- Struct 内存模型 --
struct Animal {
    private var a: Int = 1     // 8 byte
    var b: String = "animal"   // 24 byte
    var c: Kind = .wolf        // 1 byte
    var d: String?             // 25 byte
    var e: Int8 = 8            // 1 byte
    
    mutating func headPointerOfStruct() -> UnsafeMutablePointer<Int8> {
        return withUnsafeMutablePointer(to: &self) {
            return UnsafeMutableRawPointer($0).bindMemory(to: Int8.self, capacity: MemoryLayout<Self>.stride)
        }
    }
    
    func printA() {
        print("Animal a: \(a)")
    }
}

// 初始化一个 Animal 实例
var animal = Animal() // a: 1, b: "animal", c: .wolf, d: nil, e: 8
let animalPtr: UnsafeMutablePointer<Int8> = animal.headPointerOfStruct()

// Animal 类型的 size 为 8 + 24 + 8 + 25 + 1 = 66， alginment 为 8， stride 为 8 + 24 + 8 + 32 = 72.

// 如果想要通过内存修改 animal 实例的属性值，那么就需要获取到它的属性值所在的内存区域，然后修改内存区域的值，就可以达到修改 animal 属性值的目的了：
let animalRawPtr = UnsafeMutableRawPointer(animalPtr)
let intValueFromJson = 100

let aPtr = animalRawPtr.advanced(by: 0).assumingMemoryBound(to: Int.self)
aPtr.pointee   // 1
animal.printA() // Animal a: 1
aPtr.initialize(to: intValueFromJson)
aPtr.pointee // 100
animal.printA() // Animal a: 100

// MARK: -- Class 内存模型 --
// class 是引用类型, 生成的实例分布在 Heap(堆) 内存区域上, 在 Stack(栈) 只存放着一个指向堆中实例的指针。因为考虑到引用类型的动态性和 ARC 的原因, class 类型实例需要有一块单独区域存储类型信息和引用计数。

class Human {
    var age: Int?                 // 9byte (由于内存对齐, 系统实际分配 16byte)
    var name: String?             // 9byte (由于内存对齐, 系统实际分配 16byte)
    var nicknames: [String] = []  // 8byte
    
    // 返回指向 Human 实例头部的指针
    func headPointerOfClass() -> UnsafeMutablePointer<Int8> {
        let opaquePointer = Unmanaged.passUnretained(self as AnyObject).toOpaque()
        let mutableTypedPointer = opaquePointer.bindMemory(to: Int8.self, capacity: MemoryLayout<Human>.stride)
        return UnsafeMutablePointer<Int8>(mutableTypedPointer)
    }
}

MemoryLayout<Human>.size // 8

// class 类型信息区域在 32bit 的机子上是 4byte, 在 64byte 机子上是 8byte, 引用计数占用 8 byte. 所以, 在堆上, 类属性的地址是从第 16 个字节开始的.

let human = Human()
let arrFromJson = ["goudan", "zhaosi", "wangwu"]

// 拿到指向 human 堆内存的 void * 指针
let humanRawPtr = UnsafeMutableRawPointer(human.headPointerOfClass())

//let humanAgePtr = humanRawPtr.advanced(by: 16).assumingMemoryBound(to: .self)


// nicknames 数组在内存中偏移 64byte 的位置 (16 + 16 + 16)
let humanNicknamesPtr = humanRawPtr.advanced(by: 48).assumingMemoryBound(to: Array<String>.self)
human.nicknames // []

humanNicknamesPtr.initialize(to: arrFromJson)
human.nicknames // ["goudan", "zhaosi", "wangwu"]

//let firstNicknamePtr = humanRawPtr.advanced(by: 48).assumingMemoryBound(to: UnsafeMutablePointer<String>.self)
//firstNicknamePtr.pointee
