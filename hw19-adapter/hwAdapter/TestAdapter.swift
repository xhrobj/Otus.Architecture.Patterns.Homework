//
//  TestAdapter.swift
//  hwAdapter
//
//  Created by M on 10.05.2021.
//  Copyright © 2021 M. All rights reserved.
//

import UIKit

// Написать простую консольную программу П1, с интерфейсом вызова И1, которая читает данные о двух матрицах А и В из файла F0, складывает матрицы и сохраняет результат А+В в другой файл F1.
// Написать вторую консольную программу П2, которая может генерить данные матриц А и В и писать их в файл с именем F2.
// Чтобы она могла их просуммировать, следует сделать адаптер для программы П1, который позволит программе П2 вызвать П1.

class TestAdapter: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. создаем класс P1 и пытаемся вызвать у него метод сложения матриц

        let p1 = P1()
        p1.matrixAddiction()

        // 2. проверяем что содержит файл f1 - он содержит текст ошибки, если файл f0 не был создан ранее

        print("Содержимое файла f1:", loadDataFromFile("f1")!)

        // 3. запускаем метод создания матриц из класса P2

        P2.createCoupleOfMatrixes()

        // 4. проверяем что содержит файл f2 - он содержит пару созданных матриц
        // но, мы не можем сложить эти матрицы с помощью класса P1, потому что P1 ищет входные данные в другом файле

        print("Содержимое файла f2:", loadDataFromFile("f2")!)

        // 5. создаем экземпляр адаптера, который оборачивает класс P2 и, сначала вызывает метод генерации матриц класса P2,
        // а затем копирует результат работы метода, создавая копию файла f2 в файле f1,
        // приводя к соответствию (адаптируя) интерфейсы классов P1 и P2, чтобы они могли работать вместе

        let p2ToP1Adapter = P2ToP1ClassAdapter()
        p2ToP1Adapter.createDataInForP1()

        // 6. теперь вызываем метод сложения матриц класса P1

        p1.matrixAddiction()

        // 7. проверяем что содержит файл f1 - теперь он содержит результат сложения матриц из файла f0 - все ок

        print("Содержимое файла f1:", loadDataFromFile("f1")!)
    }

    private func loadDataFromFile(_ file: String) -> Any? {
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
}

protocol I1 {
    func matrixAddiction()
}

class P1: I1 {
    func matrixAddiction() {
        let fileIn = "f0"
        let fileOut = "f1"

        guard let matrixes = loadDataFromFile(fileIn) as? [[[Int]]], matrixes.count == 2 else {
            let dataOut = ["Ошибка загрузки данных"]
            saveData(dataOut, to: fileOut)
            return
        }

        let matrix1 = matrixes[0], matrix2 = matrixes[1]

        if let matrixOut = addition(matrixA: matrix1, matrixB: matrix2) {
            print("out:", matrixOut, "\n")
            saveData(matrixOut, to: fileOut)
            return
        }

        saveData(["сумма не была вычислена (проверьте входные данные)"], to: fileOut)
    }

    private func addition(matrixA: [[Int]], matrixB: [[Int]]) -> [[Int]]? {
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

    private func loadDataFromFile(_ file: String) -> Any? {
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

    private func saveData(_ data: [Any], to file: String) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(file)

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            try data.write(to: path)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}

class P2 {
    static func createCoupleOfMatrixes() {
        let testArray3 = [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [[1, 4, 7], [2, 5, 8], [3, 6, 9]]]

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("f2")

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: testArray3, requiringSecureCoding: false)
            try data.write(to: path)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}

protocol P2toP1Adapter {
    func createDataInForP1()
}

class P2ToP1ClassAdapter: P2, P2toP1Adapter {
    func createDataInForP1() {
        P2.createCoupleOfMatrixes()
        copyF2toF0()
    }

    private func copyF2toF0() {
        let pathSource = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("f2")
        let pathDestination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("f0")

        do {
            let dataArchived = try Data(contentsOf: pathSource)
            try dataArchived.write(to: pathDestination)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}
