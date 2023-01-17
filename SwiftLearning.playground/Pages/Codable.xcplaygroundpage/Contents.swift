//: [Previous](@previous)

import Foundation

/*
class HexGCD {
    /// 获取两个数的最大公约数
    class func gcd(_ a: Int, _ b: Int) -> Int {
        return b == 0 ? a : gcd(b, a % b)
    }
    
    /// 获取最大公约数
    class func gcd(_ nums: [Int]) -> Int {
        guard nums.count > 1 else { return nums.first ?? 0 }
        var result = nums.first!
        for i in 1..<nums.count {
            result = gcd(result, nums[i])
        }
        return result
    }
}

let gcd = HexGCD.gcd([2, 3])

var tasks: [String: HexGCD] = ["1": HexGCD()]
let a = tasks.values
print(tasks.values)
*/

let numbers = ["1", "2", "three", "///5///", "5"]

let mapResult = numbers.map { string in
    return Int(string)
}
print(mapResult)
// [Optional(1), Optional(2), nil, nil, Optional(5)]

let compactMapResult = numbers.compactMap { String in
    return Int(String)
}

print(compactMapResult)
// [1, 2, 5]

let letters = "abracadabra"
let letterCount = letters.reduce(into: [:]) { counts, letter in
    counts[letter, default: 0] += 1
}
print(letterCount)

struct ETSpace<T> {
    var _value: T
    init(_ value: T) {
        _value = value
    }
}

protocol ETProtocol {
    var et: ETSpace<Self> { get }
}

extension String: ETProtocol {
    var et: ETSpace<String> { ETSpace(self) }
}

extension Array: ETProtocol {
    var et: ETSpace<Self> { ETSpace(self) }
}

extension Dictionary: ETProtocol {
    var et: ETSpace<Self> { ETSpace(self) }
}


let string = "_string_of_test"
var array = string.components(separatedBy: "_")
array = array.map { $0.capitalized }
array.dropFirst()
print(array.joined(separator: ""))

//let dict = ["a_string_of_test_key": "a_string_of_test_value"]
//
//struct OlympicEventResult: Codable {
//    var goldWinner: String
//    var silverWinner: String
//    var bronzeWinner: String
//}
//
//let marathonResult = OlympicEventResult(goldWinner: "Light", silverWinner: "Sound", bronzeWinner: "Unladen Swallow")
//
JSONDecoder().keyDecodingStrategy = .convertFromSnakeCase
//let encoder = JSONEncoder()
//encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
//let encodeAndPrint = { print(String(data: try! encoder.encode(dict), encoding: .utf8)!) }
//encoder.keyEncodingStrategy = .convertToSnakeCase
//encodeAndPrint()

extension String {
    /// Convert from "snake_case_keys" to "camelCaseKeys"
    func convertFromSnakeCase() -> String {
        guard self.count > 0 else {
            return self
        }
        var string = self
        if string.firstCharacterIsCapitalized {
            string = string.prefix(1).lowercased() + string.dropFirst().prefix(upTo: string.endIndex)
        }
        
        var words = string.components(separatedBy: "_")
        guard let firstWord = words.first else { return string }
        words.removeFirst()
        words = words.map{ $0.capitalized }
        return firstWord + words.joined()
    }
    
    var firstCharacterIsCapitalized: Bool {
        let firstCharacter = self.prefix(1)
        return (firstCharacter >= "A" && firstCharacter <= "Z")
    }
}
