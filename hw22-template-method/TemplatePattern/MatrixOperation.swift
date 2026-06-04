//
//  MatrixOperation.swift
//  TemplatePattern
//
//  Created by M on 09.05.2021.
//  Copyright © 2021 M. All rights reserved.
//

import Foundation

class MatrixOperation {

    func doOperation(fileIn: String, fileOut: String) {}

    func loadDataFromFile(_ file: String) -> Any? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(file)

        do {
            let dataArchived = try Data(contentsOf: path)
            let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataArchived)
            return data
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }

        return nil
    }

    func saveData(_ data: [Any], to file: String) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(file)

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            try data.write(to: path)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}

final class MatrixOperationTranspose: MatrixOperation {
    override func doOperation(fileIn: String, fileOut: String) {
        guard let matrix = loadDataFromFile(fileIn) as? [[Int]] else {
            let dataOut = ["Ошибка загрузки данных"]
            saveData(dataOut, to: fileOut)
            return
        }

        print("* Операция транспонирования матрицы")
        print("in:", matrix)

        let matrixOut = transpose(matrix)

        print("out:", matrixOut, "\n")

        saveData(matrixOut, to: fileOut)
    }

    private func transpose(_ matrix: [[Int]]) -> [[Int]] {
        // https://ru.wikipedia.org/wiki/%D0%A2%D1%80%D0%B0%D0%BD%D1%81%D0%BF%D0%BE%D0%BD%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D0%B0%D1%8F_%D0%BC%D0%B0%D1%82%D1%80%D0%B8%D1%86%D0%B0
        // NOTE: в целях упрощения транспонируем только квадратные матрицы

        var matrix = matrix

        if matrix.isEmpty {
            return matrix
        }

        let rows = matrix.count
        let cols = matrix[0].count

        if rows != cols {
            return matrix
        }

        for y in 0..<rows {
            for x in 0..<cols {
                if x <= y {
                    continue
                }
                let tmp = matrix[y][x]
                matrix[y][x] = matrix[x][y]
                matrix[x][y] = tmp
            }
        }

        return matrix
    }
}

final class MatrixOperationDeterminant: MatrixOperation {
    override func doOperation(fileIn: String, fileOut: String) {
        guard let matrix = loadDataFromFile(fileIn) as? [[Int]] else {
            let dataOut = ["Ошибка загрузки данных"]
            saveData(dataOut, to: fileOut)
            return
        }

        print("* Операция нахождения определителя матрицы")
        print("in:", matrix)

        if let determinant = figureOutDeterminant(matrix) {
            print("определитель:", determinant, "\n")
            saveData([determinant], to: fileOut)
            return
        }

        let m = "определитель: не был вычислен (проверьте входные данные)"
        print(m, "\n")
        let dataOut = [m]
        saveData(dataOut, to: fileOut)
    }

    private func figureOutDeterminant(_ matrix: [[Int]]) -> Int? {
        // https://ru.wikipedia.org/wiki/%D0%9E%D0%BF%D1%80%D0%B5%D0%B4%D0%B5%D0%BB%D0%B8%D1%82%D0%B5%D0%BB%D1%8C
        // NOTE: в целях упрощения ищем определитель только для единичных матриц и матриц вида 2x2

        if matrix.isEmpty {
            return nil
        }

        let rows = matrix.count
        if rows > 2 {
            return nil
        }
        let cols = matrix[0].count

        if rows != cols {
            return nil
        }

        let a = matrix[0][0]

        if rows == 1 {
            return a
        }

        let b = matrix[1][0]
        let c = matrix[0][1]
        let d = matrix[1][1]

        return a * d - b * c
    }
}

final class MatrixOperationAddition: MatrixOperation {
    override func doOperation(fileIn: String, fileOut: String) {
        guard let matrixes = loadDataFromFile(fileIn) as? [[[Int]]], matrixes.count == 2 else {
            let dataOut = ["Ошибка загрузки данных"]
            saveData(dataOut, to: fileOut)
            return
        }

        let matrix1 = matrixes[0], matrix2 = matrixes[1]

        print("* Операция сложения двух матрицы")
        print("in:", matrix1, matrix2)

        if let matrixOut = addition(matrixA: matrix1, matrixB: matrix2) {
            print("out:", matrixOut, "\n")
            saveData(matrixOut, to: fileOut)
            return
        }

        let m = "сумма не была вычислена (проверьте входные данные)"
        print(m, "\n")
        let dataOut = [m]
        saveData(dataOut, to: fileOut)
    }

    private func addition(matrixA: [[Int]], matrixB: [[Int]]) -> [[Int]]? {
        // https://ru.wikipedia.org/wiki/%D0%9C%D0%B0%D1%82%D1%80%D0%B8%D1%86%D0%B0_(%D0%BC%D0%B0%D1%82%D0%B5%D0%BC%D0%B0%D1%82%D0%B8%D0%BA%D0%B0)

        if matrixA.count == 0 && matrixB.count == 0 {
            return matrixA
        }

        let rowsMatrixA = matrixA.count
        let colsMatrixA = matrixA[0].count

        let rowsMatrixB = matrixB.count
        let colsMatrixB = matrixB[0].count

        if rowsMatrixA != rowsMatrixB || colsMatrixA != colsMatrixB {
            // NOTE: "Складывать можно только матрицы одинакового размера"
            return nil
        }

        var matrixOut = Array(repeating: Array(repeating: 0, count: colsMatrixA), count: rowsMatrixA)
        for i in 0..<rowsMatrixA {
            for j in 0..<colsMatrixA {
                matrixOut[i][j] = matrixA[i][j] + matrixB[i][j]
            }
        }

        return matrixOut
    }
}

