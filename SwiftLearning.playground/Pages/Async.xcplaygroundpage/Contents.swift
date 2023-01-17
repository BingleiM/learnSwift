//: [Previous](@previous)

import Foundation

func fetchUserID(from server: String) async -> Int {
    if server == "primary" {
        return 97
    }
    return 501
}

func fetchUsername(from server: String) async -> String {
    let userID = await fetchUserID(from: server)
    if userID == 501 {
        return "John Appleseed"
    }
    return "Guest"
}

func connectUser(to server: String) async {
    async let userID = fetchUserID(from: server)
    async let username = fetchUsername(from: server)
    let greeting = await "Hello \(username), user ID \(userID)"
    print(greeting)
}

Task {
    await connectUser(to: "primary")
}

struct TaskGroupSample {
    func start() async {
        print("Start")
        // 1
        await withTaskGroup(of: Int.self, body: { group in
            for i in 0...3 {
                // 2
                group.addTask {
                    await work(i)
                }
            }
            print("Task added")
            
            // 4
//            for await result in group {
//                print("Get result: \(result)")
//            }
            
            // 5
            print("Task ended")
        })
        
        print("End")
    }
    
    private func work(_ value: Int) async -> Int {
        // 3
        print("Start work \(value)")
        try? await Task.sleep(nanoseconds: UInt64(value) * NSEC_PER_SEC)
        print("Work \(value) done")
        return value
    }
}

let taskGroupSample = TaskGroupSample()
await taskGroupSample.start()

enum SomeError: Error {
    case illegalArg(String)
    case outOfBounds(Int, Int)
    case outOfMemory
}

func divide(_ num1: Int, _ num2: Int) throws -> Int {
    if num2 == 0 {
        throw SomeError.illegalArg("0不能作为除数")
    }
    return num1/num2
}

func exec(_ fn: (Int, Int) throws -> Int, _ num1: Int, _ num2: Int) rethrows {
    print(try fn(num1, num2))
}

do {
    try exec(divide(_:_:), 20, 0)
} catch {
    print(error)
}

var result = try divide(6, 2)

// 处理方式一: 用 do-catch 处理异常
do {
    print(try divide(20, 0))
} catch let SomeError.illegalArg(msg) {
    print("异常参数：", msg)
} catch let SomeError.outOfBounds(size, index) {
    print("下标越界: ", "size=\(size)")
} catch SomeError.outOfMemory {
    print("内存溢出")
} catch {
    print("其他错误")
}

// 处理方式二： throws
func test() throws {
    try divide(1, 0)
}

print(try? divide(20, 10))
print(try? divide(20, 0))
print(try divide(20, 1))

// concurrentPerform 相当于 dispatch_apply(<#size_t iterations#>, <#dispatch_queue_t  _Nullable queue#>, <#^(size_t iteration)block#>)
DispatchQueue.concurrentPerform(iterations: 5) { index in
    debugPrint("\(index). concurrentPerform")
}
