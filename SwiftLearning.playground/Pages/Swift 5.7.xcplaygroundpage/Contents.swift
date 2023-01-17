//: [Previous](@previous)

import Foundation

// MARK: -- 1.简化的 if let/guard let 语法 --
// 引入了新的速记语法，可以将可选型展开为同名的变量。以后我们可以像下面这样解包了：
func ifLetSample() {
    let name: String? = "Damon"
    print(name) // Optional("Damon")

    // Swift 5.7 之前
    // if let
    if let name = name {
        print(name) // Damon
    }

    // Swift 5.7 之后
    if let name {
        print(name) // Damon
    }
}

func guardletSample(name: String?, age: Int?) {
    // Swift 5.7 之前
    // guard let
    guard let name = name else { return }
    
    // Swift 5.7 之后
    // guard let
    guard let age else { return }
    
    print("姓名:\(name), 年龄: \(age)")
}

// MARK: -- 增强的闭包类型推断 --
// 极大地提高了 Swift 对闭包使用参数和类型推断的能力，这意味着我们现在可以删除许多必须明确指定输入和输出类型的写法。
func closureSample() {
    let array = ["11", "2", "3", "40", "5"]
    // Swift 5.7 之前
    let mapArray1 = array.map { str -> Int in
        if str.count > 1 {
            return Int(str) ?? 0
        } else {
            return Int(10)
        }
    }
    
    // Swift 5.7 之后
    let mapArray2 = array.map { str in
        if str.count > 1 {
            return Int(str) ?? 0
        } else {
            return Int(10)
        }
    }
}

// MARK: -- 函数参数与返回类型支持不透明结果类型 --
// 解锁了在使用更简单泛型的地方对参数声明使用 some 的能力。
// some --- 用在当返回值为不确定类型的情况。
// some类型只对已声明的属性和下标类型以及函数的返回类型实现

// 举个例子，如果我们想编写一个检查数组是否排序的函数，Swift 5.7 及更高版本允许我们这样写：
func isSorted(_ array: [some Comparable]) -> Bool {
    array == array.sorted()
}

// [some Comparable] 参数类型意味着此函数适用于包含某种类型的元素的数组，该类型遵循 Comparable
// 等同于下面的方式
func isSortedBefore<T: Comparable>(_ array: [T]) -> Bool {
    array == array.sorted()
}

extension Array where Element: Comparable {
    func isSorted() -> Bool {
        self == self.sorted()
    }
}

// MARK: -- 结构化的不透明结果类型 --
// 现在可以一次返回多个不透明类型
func showUserDetails() -> (some Equatable, some Equatable) {
    ("damon", 100)
}

// MARK: -- 不可异步属性 --
// 通过允许我们将类型和函数标记为在异步上下文中不可用，部分屏蔽了 Swift 并发模型中的潜在风险情况。
@available(*, noasync)
func doRiskyWork() {}

// 在常规的同步函数中，我们可以正常调用它
func synchronousCaller() {
    doRiskyWork()
}

// 假如我们试图在异步函数中也这么做，Swift 会指出错误：
func asynchronousCaller() async {
    doRiskyWork()
}

// 这个保护机制是一种改进，但我们不应过度依赖它。因为它无法防范我们把调用嵌套到同步函数内部的情况，例如：
func sneakyCaller() async {
    synchronousCaller()
}

// 上面的代码在异步上下文中运行，但调用同步函数，该函数又可以调用 noasync 函数 doRiskyWork()。

// MARK: -- 正则表达式 --
let message = "the cat sat on the mat"
print(message.ranges(of: "at"))
print(message.replacing("cat", with: "dog"))
print(message.trimmingPrefix("the "))

// 寻找"The"
print(message.trimmingPrefix(/The/.ignoresCase()))

// Swift 还提供了专门的 Regex 类型
do {
    let atSearch = try Regex("[a-z]at")
    let ranges = message.ranges(of: atSearch)
    for range in ranges {
        print("===> ", message[range])
    }
//    print(message.ranges(of: atSearch))
} catch {
    print("Failed to create regex")
}

// 这里两种方式有一个关键区别：当我们使用 Regex 从字符串创建正则表达式时，Swift 必须在运行时解析字符串以找出它应该使用的实际表达式。相比之下，使用正则表达式字面量允许 Swift 在编译时 检查你的正则表达式：它可以验证正则表达式不包含错误，并且还可以准确了解它将包含什么匹配项。
func regularFunc() {
    let message = "This is a regex test case 123456789 一二三"
    
    do {
        // 字符串中搜索 regex
        let regex = try Regex("[a-z] regex")
        let index = message.ranges(of: regex)
        
        print("范围===> ", index)
        print(message.replacing(regex, with: "正则表达式"))
    } catch {
        print("Failed to create regex")
    }
}

// MARK: -- 新的时间表示法 --
// Swift 引入了一种新的标准化方式来引用时间和持续时间。它可以拆解为三个主要部分：
// Clock：表示一种测量时间流逝的方式。又分为 2 种。
// ContinuousClock：系统处于睡眠状态时也会记录时间。
// SuspendingClock：系统处于睡眠状态时不会记录时间。
// Instant：表示一个精准的瞬间时间。
// Duration：表示 2 个Instant之间的时间间隔。

func download() async throws -> Data? {
    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://devstreaming-cdn.apple.com/videos/tech-talks/10067/3/F8DADC3E-4CC2-4165-AD4A-5B6A2DBFCF29/downloads/tech-talks-10067_hd.mp4?dl=1")!)
    return data
}

func clockSample() async {
    // 当前时间 + 3秒
    ContinuousClock.Instant.now + Duration.seconds(3)
    // 当前时间 + 50毫秒
    ContinuousClock.Instant.now + Duration.microseconds(50)
    
    // 应用于 Concurrency
    try? await Task.sleep(until: .now + .seconds(1), clock: .suspending)
    try? await Task.sleep(until: .now + .seconds(1), tolerance: .seconds(0.5), clock: .continuous)
}

func clockSample1() async throws {
    // 异步函数
    func doSomeAsyncWork() async throws {
        try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
    }

    // SuspendingClock
    let suspendingClock = SuspendingClock()
    // 测量闭包中任务执行耗时
    let elapsedOne = try await suspendingClock.measure {
        try await doSomeAsyncWork()
    }

    // ContinuousClock
    let continuousClock = ContinuousClock()
    // 测量闭包中任务执行耗时
    let elapsedTwo = try await continuousClock.measure {
        async let downloadData = download()
        let data = try await downloadData
        print("donwload data size: \(data?.count ?? 0)")
    }
}

// MARK: -- Asynchronous Sequences 异步队列 --

final class Person: @unchecked Sendable {
    var age: Int = 0
}

let handle = FileHandle.standardInput
for try await line in handle.bytes.lines {
    print(line)
}
