//: [Previous](@previous)
// 详见: https://www.jianshu.com/p/2321e1d2afe8
import Foundation
import UIKit

// MARK: -- BlockOperation --
func blockOperationExample() {
    let blockOperation = BlockOperation()
    
    for i in 1...10 {
        blockOperation.addExecutionBlock {
            sleep(2)
            print("\(i) in blockOperation: \(Thread.current)")
        }
    }
    
    blockOperation.completionBlock = {
        print("All block operation task finished: \(Thread.current)")
    }
    
    blockOperation.start()
}

blockOperationExample()

// MARK: -- OperationQueue --
func operationQueueExample() {
    let queue = OperationQueue()
    queue.addOperation { print("厉"); sleep(3) }
    queue.addOperation { print("害"); sleep(3) }
    queue.addOperation { print("了"); sleep(3) }
    queue.addOperation { print("我"); sleep(3) }
    queue.addOperation { print("的"); sleep(3) }
    queue.addOperation { print("哥"); sleep(3) }
    
    // 阻塞
    queue.waitUntilAllOperationsAreFinished()
}

operationQueueExample()
