import Foundation

protocol FibonacciIterator {
    var currentIndex: Int { set get }
    func getNextValue() -> Int?
}

class FibonacciIteractorFactory {
    enum SortType {
        case straight, reverse
    }

    static func makeIterator(type: SortType) -> FibonacciIterator {
        switch type {
        case .straight:
            return FibonacciIteratorStraight()
        case .reverse:
            return FibonacciIteratorReverse()
        }
    }
}

class FibonacciIteratorStraight: FibonacciIterator {
    var currentIndex = 0

    func getNextValue() -> Int? {
        if currentIndex < 0 {
            return nil
        }
        let nextFibonacciNumber = fibonacci(for: currentIndex)
        currentIndex += 1
        return nextFibonacciNumber
    }

    private func fibonacci(for index: Int) -> Int {
        // 0, 1, 1, 2, 3, 5, 8, 13 ...
        if index == 0 || index == 1 {
            return index
        }
        var valuePrev = 1, valuePrevPrev = 0
        for _ in 2...index {
            let valueCurrent = valuePrev + valuePrevPrev
            valuePrevPrev = valuePrev
            valuePrev = valueCurrent
        }
        return valuePrev
    }
}

class FibonacciIteratorReverse: FibonacciIterator {
    var currentIndex = 0

    func getNextValue() -> Int? {
        if currentIndex < 0 {
            return nil
        }
        let nextFibonacciNumber = fibonacci(for: currentIndex)
        currentIndex -= 1
        return nextFibonacciNumber
    }

    private func fibonacci(for index: Int) -> Int {
        let squareRootOf5 = 5.0.squareRoot()
        let a = (1 + squareRootOf5) / 2;
        return Int((pow(a, Double(index))  / squareRootOf5).rounded())
    }
}

// Получим последовательность Фибоначчи с индексами от 0 до 15

var fibonacciIterator = FibonacciIteractorFactory.makeIterator(type: .straight)
fibonacciIterator.currentIndex = 0
var result = [Int]()
while fibonacciIterator.currentIndex <= 15 {
    guard let nextFibonacciNumber = fibonacciIterator.getNextValue() else { break }
    result.append(nextFibonacciNumber)
}
print(result) // Вывод: [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610]

// Получим последовательность Фибоначчи с индексами от 15 до 0

var fibonacciReverseIterator = FibonacciIteractorFactory.makeIterator(type: .reverse)
fibonacciReverseIterator.currentIndex = 15
result = []
while fibonacciReverseIterator.currentIndex >= 0 {
    guard let nextFibonacciNumber = fibonacciReverseIterator.getNextValue() else { break }
    result.append(nextFibonacciNumber)
}
print(result) // Вывод: [610, 377, 233, 144, 89, 55, 34, 21, 13, 8, 5, 3, 2, 1, 1, 0]
