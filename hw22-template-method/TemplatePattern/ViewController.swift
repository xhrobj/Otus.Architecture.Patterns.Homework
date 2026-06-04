//
//  ViewController.swift
//  TemplatePattern
//
//  Created by M on 09.05.2021.
//  Copyright © 2021 M. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        createDataIn()
        testMatrixOperations()
    }

    private func createDataIn() {
        // создаем входные файлы с примерами для каждой операции
        GenerateData.createFilesWithDataIn()
    }

    private func testMatrixOperations() {
        // 1. транспонирование:
        let operationTranspose = MatrixOperationTranspose()
        operationTranspose.doOperation(fileIn: "transposeIn", fileOut: "transponseOut")

        // 2. нахождение определителя:
        let operationDeterminant = MatrixOperationDeterminant()
        operationDeterminant.doOperation(fileIn: "determinantIn", fileOut: "determinantOut")

        // 3. сложение матриц:
        let operationAddition = MatrixOperationAddition()
        operationAddition.doOperation(fileIn: "additionIn", fileOut: "additionOut")
    }
}
