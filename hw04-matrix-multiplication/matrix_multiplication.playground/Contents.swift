import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// https://ru.wikipedia.org/wiki/%D0%A3%D0%BC%D0%BD%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5_%D0%BC%D0%B0%D1%82%D1%80%D0%B8%D1%86

let matrixA: Array<Array<Int>> = [[1, 2],
                                 [3, 4]]

let matrixB: Array<Array<Int>> = [[1, 6],
                                 [3, 4]]
struct MatrixElement {
    let i: Int
    let j: Int
    let element: Int
}

print("Матрица 1:", matrixA)
print("Матрица 2:", matrixB)

var result: Array<MatrixElement> = []
let n = matrixA.count

let q1 = DispatchQueue(label: "q1", attributes: [.concurrent])
let q2 = DispatchQueue(label: "q2")

let group = DispatchGroup()

for i in 0..<n {
    for j in 0..<n {
        q1.async(group: group) {
            print("Элемент (\(i),\(j)) вычисление начато")
            let element = calculateElement(A: matrixA, B: matrixB, i: i, j: j, n: n)
            print("Элемент (\(i),\(j)) вычисление закончено: \(element)")
            q2.async {
                print("Элемент (\(i),\(j)) запись результата начата")
                result.append(MatrixElement(i: i, j: j, element: element))
                print("Элемент (\(i),\(j)) запись результата закончена")
            }
        }
    }
}

group.notify(queue: q2) {
    var matrixResult = [[Int]]()
    for i in 0..<n {
        var row = [Int]()
        for j in 0..<n {
            for element in result {
                if element.i == i && element.j == j {
                    row.append(element.element)
                    break
                }
            }
        }
        matrixResult.append(row)
    }
    print("Вычиcления закончены. Результирующая матрица:", matrixResult)
}

func calculateElement(A: Array<Array<Int>>, B: Array<Array<Int>>, i: Int, j: Int, n: Int) -> Int {
    var sum = 0
    for k in 0..<n {
        sum += A[i][k] * B[k][j]
    }
    sleep(UInt32(Int.random(in: 0...2)))
    return sum
}
