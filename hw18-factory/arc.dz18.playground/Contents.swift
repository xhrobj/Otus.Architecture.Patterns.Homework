protocol Sorter {
    var title: String { get }
    func sort(_ input: [Int]) -> [Int]
}

class SortFactory {
    enum SortType {
        case bubble, insertion, selection
    }

    enum OutputType {
        case console, file
    }

    func makeSorter(type: SortType) -> Sorter {
        switch type {
        case .bubble:
            return BubbleSort()
        case .insertion:
            return InsertionSort()
        case .selection:
            return SelectionSort()
        }
    }
}

class BubbleSort: Sorter {
    let title = "Bubble Sort"

    func sort(_ input: [Int]) -> [Int] {
        guard input.count > 1 else { return input }

        var output: [Int] = input

        for primaryIndex in 0..<output.count {
            let passes = (output.count - 1) - primaryIndex
            for secondaryIndex in 0..<passes {
                let key = output[secondaryIndex]
                if key > output[secondaryIndex + 1] {
                    output.swapAt(secondaryIndex, secondaryIndex + 1)
                }
            }
        }

        return output
    }
}

class InsertionSort: Sorter {
    let title = "Insertion Sort"

    func sort(_ input: [Int]) -> [Int] {
        guard input.count > 1 else { return input }

        var output: [Int] = input

        for primaryindex in 0..<output.count {
            let key = output[primaryindex]
            var secondaryindex = primaryindex

            while secondaryindex > -1 {
                if key < output[secondaryindex] {
                    output.remove(at: secondaryindex + 1)
                    output.insert(key, at: secondaryindex)
                }
                secondaryindex -= 1
            }
        }

        return output
    }
}

class SelectionSort: Sorter {
    let title = "Selection Sort"

    func sort(_ input: [Int]) -> [Int] {
        guard input.count > 1 else { return input }

        var output: [Int] = input

        for primaryindex in 0..<output.count {
            var minimum = primaryindex
            var secondaryindex = primaryindex + 1

            while secondaryindex < output.count {
                if output[minimum] > output[secondaryindex] {
                    minimum = secondaryindex
                }
                secondaryindex += 1
            }

            if primaryindex != minimum {
                output.swapAt(primaryindex, minimum)
            }
        }

        return output
    }
}

let numberList = [8, 2, 10, 9, 7, 5]

let insertionSorter = SortFactory().makeSorter(type: .insertion)
print(insertionSorter.title) // вывод: Insertion Sort
print(insertionSorter.sort(numberList)) // вывод: [2, 5, 7, 8, 9, 10]

let bubbleSorter = SortFactory().makeSorter(type: .bubble)
print(bubbleSorter.title) // вывод: Bubble Sort
print(bubbleSorter.sort(numberList)) // вывод: [2, 5, 7, 8, 9, 10]

let selectionSorter = SortFactory().makeSorter(type: .selection)
print(selectionSorter.title) // вывод: Selection Sort
print(selectionSorter.sort(numberList)) // вывод: [2, 5, 7, 8, 9, 10]
