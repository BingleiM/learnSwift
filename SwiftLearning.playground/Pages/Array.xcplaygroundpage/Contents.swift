//: [Previous](@previous)

import Foundation

// MARK: -- 用数组实现栈 --
class Stack {
    var stack: [AnyObject]
    var isEmpty: Bool { return stack.isEmpty }
    var peek: AnyObject? { return stack.last }
    
    init() {
        stack = [AnyObject]()
    }
    
    func push(object: AnyObject) {
        stack.append(object)
    }
    
    func pop() -> AnyObject? {
        if !isEmpty {
            return stack.removeLast()
        } else {
            return nil
        }
    }
}

// 用字典和高阶函数计算字符串中每个字符出现频率
let keys = [("a", 1), ("b", 2), ("a", 3), ("b", 4)]
let dict = Dictionary(keys, uniquingKeysWith: +)
// print(dict) // ["a": 4, "b": 6]

/// 查询数组中是否有两数之和等于 target
func twoSum(nums: [Int], _ target: Int) -> Bool {
    var set = Set<Int>()
    for num in nums {
        if set.contains(target - num) {
            return true
        }
        set.insert(num)
    }
    return false
}

/// 查询数组中两数之和等于 target 的下标(只有一对)
func twoSum(nums: [Int], _ target: Int) -> [Int] {
    var dict: [Int: Int] = [:]
    for (i, num) in nums.enumerated() {
        if let lastIndex = dict[target - num] {
            return [lastIndex, i]
        } else {
            dict[num] = i
        }
    }
    return []
}

class ListNode: Hashable {
    
    var val: Int
    var next: ListNode?
    
    init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(val)
        hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension ListNode: CustomStringConvertible {
    var description: String {
        var vals: [Int] = []
        var curNode: ListNode? = self
        while curNode != nil {
            vals.append(curNode!.val)
            curNode = curNode!.next
        }
        return vals.map { String($0) }.joined(separator: " -> ")
    }
}

class LinkedList: CustomStringConvertible {
    var head: ListNode?
    var tail: ListNode?
    
    var description: String {
        var vals: [Int] = []
        var node = head == nil ? tail : head
        if node != nil {
            while node != nil {
                vals.append(node!.val)
                node = node?.next
            }
        }
        return vals.map { String($0) }.joined(separator: " -> ")
    }
    
    init?(vals: [Int]) {
        guard vals.count > 0 else { return nil }
        let dummy = ListNode(0)
        var node: ListNode? = dummy
        vals.map { ListNode($0) }.forEach {
            node?.next = $0
            node = $0
        }
        self.head = dummy.next
        self.tail = nil
    }
    
    // 尾差法
    func appendToTail(_ val: Int) {
        if tail == nil {
            tail = ListNode(val)
        } else {
            tail?.next = ListNode(val)
            tail = tail?.next
        }
    }
    
    // 头差法
    func appendToHead(_ val: Int) {
        if head == nil {
            head = ListNode(val)
        } else {
            let temp = ListNode(val)
            temp.next = head
            head = temp
        }
    }
    
    /* 给出一个链表和一个值x，要求将链表中所有小于x的值放到左边，所有大于或等于x 的 值放到右边， 并且原链表的节点顺序不能变
    例 如 : 1 → 5 → 3 → 2 → 4 → 2 ， 给 定 x = 3 ， 则 要 返国 1 → 2 → 2 → 5 → 3 → 4
    */
    class func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
        let prevdummy = ListNode(0), postDummy = ListNode(0)
        var prev = prevdummy, post = postDummy
        var node = head
        
        while node != nil {
            if node!.val < x {
                prev.next = node
                prev = node!
            } else {
                post.next = node
                post = node!
            }
        }
        
        post.next = nil
        prev.next = postDummy.next
        
        return prevdummy.next
    }
    
    class func hasCycle(_ head: ListNode?) -> Bool {
        var slow = head
        var fast = head
        while fast != nil, fast?.next != nil {
            slow = slow?.next
            fast = fast?.next?.next
            if slow == fast {
                return true
            }
        }
        return false
    }
}

let vals = [1, 5, 3, 2, 4, 2]
let list = LinkedList(vals: vals)
debugPrint(list?.description)
