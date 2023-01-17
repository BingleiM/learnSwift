import Foundation

let integerResult: Result<Int, Error> = .success(5)
do {
    let value = try integerResult.get()
    let stringValue = integerResult.map { String($0) }
    print("The value is \(value)")
    print("The string value is \(stringValue)")
} catch {
    print("Error retrieving the value: \(error)")
}

func getNextInter() -> Result<Int, Error> {
    return .success(5)
}

func getNextAfterInteger(_ n: Int) -> Result<Int, Error> {
    return .success(n + 1)
}

let result = getNextInter().map { getNextAfterInteger($0) }
let aresult = getNextInter().flatMap { getNextAfterInteger($0) }
print(result)
print(aresult)


