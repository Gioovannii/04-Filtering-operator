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
