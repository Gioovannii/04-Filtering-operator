import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()


example(of: "filtering") {
    // 1 Crate a publisher which emit value from 1 to 10
    let numbers = (1...10).publisher
    
    // 2 Use filter operator to allow to filter only multiple of 3
    numbers
        .filter { $0.isMultiple(of: 3) }
        .sink(receiveValue: { n in
            print("\(n) is a multiple of 3")
        })
        .store(in: &subscriptions)
}
    
    example(of: "removeDuplicates") {
        // 1 Separate a sentance into an array of words and create a publisher to emit these words
        let words = "hey hey there! I want to listen to mister mister ?"
            .components(separatedBy: " ")
            .publisher
        
        // 2 Apply removeDuplicates() to word publisher
        words
            .removeDuplicates()
            .sink { print($0) }
            .store(in: &subscriptions)
    }
    
    example(of: "compactMap") {
        // 1 create a publisher emit a finite list of string
        let strings = ["a", "1.24", "3",
                       "def", "45", "0.23"].publisher
        
        // 2 Use compact map to attempt initialize float or nil
        strings
            .compactMap { Float($0) }
            .removeDuplicates()
            .sink(receiveValue: {
                    // 3 Only succesfull string will be print out
                    print($0) })
            .store(in: &subscriptions)
    }
    
    example(of: "ignoreOutput") {
        // 1 create publisher from 1 to 10k
        let numbers = (1...10_000).publisher
        
        // ignore output which omit all values
        numbers
            .ignoreOutput()
            .sink(receiveCompletion: { print("Completed with: \($0)")},
                  receiveValue: { print($0) })
            .store(in: &subscriptions)
    }

example(of: "first(where:)") {
    // 1 Create a new publisher emiting numbers from 1 through 9
    let numbers = (1...9).publisher
    
    // 2 Use first(where:) to find the first
    numbers
        .print("numbers")
        .first(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}


example(of: "last(where:)") {
    // 1
    let numbers = (1...9).publisher

    // 2
    numbers
        .last(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)

}

example(of: "last(where:)") {
    let numbers = PassthroughSubject<Int, Never>()
    
    numbers
        .last(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    numbers.send(1)
    numbers.send(2)
    numbers.send(3)
    numbers.send(4)
    numbers.send(5)
    
    numbers.send(completion: .finished)
}

example(of: "dropFirst") {
    // 1 Create a publisher from 1 to 10
    let numbers = (1...10).publisher
    
    // 2 frop the first 8 values
    numbers
        .dropFirst(8)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "drop(while:)") {
    // 1 Create publisher
    let numbers = (1...10).publisher
    
    // 2 Use frop while to wait first value which is divisible by 5
    numbers
        .drop(while: { $0 % 5 != 0 })
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "drop(while:)") {
    let numbers = (1...10).publisher
    
    numbers
        .drop(while: {
            print("x")
            return $0 % 5 != 0
        })
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "drop(untilOutputFrom:)") {
    // 1 set passthrough subject that can manually send values
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()
    
    // 2 drop to ignore taps until isReadyemit at leat one value
    taps
        .drop(untilOutputFrom: isReady)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 3 send taps when condition is valid
    (1...5).forEach { n in
        taps.send(n)
        
        if n == 3 {
            isReady.send()
        }
    }
}

example(of: "prefix") {
    // 1 Create a publisher
    let numbers = (1...10).publisher
    
    // 2 Use prefix(2) to allow emission first two values
    numbers
        .prefix(2)
        .sink(receiveCompletion: { print("Compled with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "prefix(while:)") {
    // 1 create a publisher
    let numbers = (1...10).publisher
    
    // 2 Use prefix whil to evaluate condition
    numbers
        .prefix(while: { $0 < 3 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "prefix(untilOutputFrom:)") {
    // 1 Create two passtroughSubject
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()
    
    // 2 us prefix to let tap evend until isReady emit value
    taps
        .prefix(untilOutputFrom: isReady)
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
    
    // 3 send five taps through subject exactly as diagram above
    (1...5).forEach { n in
        taps.send(n)
        if n == 2 {
            isReady.send()
        }
    }
}

/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
