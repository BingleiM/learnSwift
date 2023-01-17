//: [Previous](@previous)

import Foundation

// MARK: -- 泛型 --

// 1. 交换两个变量的值
func swap<T>(_ a: inout T, _ b: inout T) {
    (b, a) = (a, b)
}

var a = 10
var b = 100
swap(&a, &b)
print("a: \(a), b: \(b)")

// 2.模仿栈存储数据
struct Stack<Element> {
    var items = [Element]()
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop(_ item: Element) -> Element {
        items.removeLast()
    }
}

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items.last
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")

print(stackOfStrings.topItem)

// 3. 类型约束的应用
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

/* 关联类型
 定义一个协议时，有时在协议定义里声明一个或多个关联类型是很有用的。关联类型给协议中用到的类型一个占位符名称。直到采纳协议时，才指定用于该关联类型的实际类型。关联类型通过 associatedtype 关键字指定。
*/

// 4.关联类型的应用
// 这里是一个焦作 Container 的示例协议, 声明了一个叫做 ItemType 的关联类型
protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

extension Stack: Container {
    typealias ItemType = Element
    var count: Int { items.count }
    
    mutating func append(_ item: Element) {
        items.append(item)
    }
    
    subscript(i: Int) -> Element {
        return items[i]
    }
}

protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.ItemType == ItemType
    func suffix(_ size: Int) -> Suffix
}

extension Stack: SuffixableContainer {
    func suffix(_ size: Int) -> Stack {
        var result = Stack()
        for index in (count - size)..<count {
            result.append(self[index])
        }
        return result
    }
    // Inferred that Suffix is Stack.
}

var stackOfInts = Stack<Int>()
stackOfInts.append(10)
stackOfInts.append(20)
stackOfInts.append(30)
let suffix = stackOfInts.suffix(2) // suffix contains 20 and 30

// MARK: -- 模块和源文件 --
// Swift 的访问控制模型基于模块和源文件的概念。
// 模块是单一的代码分配单元——一个框架或应用程序会作为的独立的单元构建和发布并且可以使用 Swift 的 import 关键字导入到另一个模块。

// MARK: -- 访问级别 --
/*
Swift 为代码的实体提供个五个不同的访问级别。这些访问级别和定义实体的源文件相关，并且也和源文件所属的模块相关。

Open 访问 和 public 访问 允许实体被定义模块中的任意源文件访问，同样可以被另一模块的源文件通过导入该定义模块来访问。在指定框架的公共接口时，通常使用 open 或 public 访问。 open 和 public 访问 之间的区别将在之后给出；
Internal 访问 允许实体被定义模块中的任意源文件访问，但不能被该模块之外的任何源文件访问。通常在定义应用程序或是框架的内部结构时使用。
File-private 访问 将实体的使用限制于当前定义源文件中。当一些细节在整个文件中使用时，使用 file-private 访问隐藏特定功能的实现细节。
private 访问 将实体的使用限制于封闭声明中。当一些细节仅在单独的声明中使用时，使用 private 访问隐藏特定功能的实现细节。
 open 访问是最高的（限制最少）访问级别，private 是最低的（限制最多）访问级别。

open 访问仅适用于类和类成员，它与 public 访问区别如下：

public 访问，或任何更严格的访问级别的类，只能在其定义模块中被继承。
public 访问，或任何更严格访问级别的类成员，只能被其定义模块的子类重写。
open 类可以在其定义模块中被继承，也可在任何导入定义模块的其他模块中被继承。
open 类成员可以被其定义模块的子类重写，也可以被导入其定义模块的任何模块重写。
显式地标记类为 open 意味着你考虑过其他模块使用该类作为父类对代码的影响，并且相应地设计了类的代码。
*/
