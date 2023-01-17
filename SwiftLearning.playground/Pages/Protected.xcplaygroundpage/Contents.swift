
import Foundation

private protocol Lock {
    func lock()
    func unlock()
}

extension Lock {
    func around<T>(_ closure: () throws -> T) rethrows -> T {
        lock(); defer { unlock() }
        return try closure()
    }
    
    func around(_ closure: () throws -> Void) rethrows {
        lock(); defer { unlock() }
        try closure()
    }
}

final public class UnfairLock: Lock {
    private let unfairLock: os_unfair_lock_t
    
    init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }
    
    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }
    
    fileprivate func lock() {
        os_unfair_lock_lock(unfairLock)
    }
    
    fileprivate func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
}

@propertyWrapper
final class Protected<T> {
    private let lock = UnfairLock()
    private var value: T
    
    init(_ value: T) {
        self.value = value
    }
    
    var wrappedValue: T {
        get { lock.around { value } }
        set { lock.around { value = newValue } }
    }
}

class Sample {
    @Protected("haha") var name: String
    @Protected(0) var age: Int
    @Protected(53.5) var weight: Double
    func test(_ a: Int) throws -> Void {
        if a > 0 {
            print("OK")
        } else {
            throw NSError(domain: "com.mabinglei", code: 101, userInfo: [NSLocalizedFailureReasonErrorKey: "Not OK"])
        }
    }
    
    func sa(_ a: (Int) throws -> Void, _ b: Int) rethrows {
        try a(b)
    }
}

@objcMembers
@propertyWrapper
class UserDefaultWrapper<T> {
    private let storage: UserDefaults = UserDefaults.standard
    private let key: String
    private var defaultValue: T? = nil
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: T? {
        get { storage.value(forKey: key) as? T ?? defaultValue }
        set { storage.set(newValue, forKey: key) }
    }
}

struct UserDefaultSample {
    @UserDefaultWrapper(key: "name", defaultValue: "Damon")
    var name: String?
    @UserDefaultWrapper(key: "age")
    var age: Int?
}

let udSample = UserDefaultSample()
print(udSample.name)
udSample.name = "John"
print(udSample.name)
let sample = Sample()
try sample.sa(sample.test(_:), -5)

