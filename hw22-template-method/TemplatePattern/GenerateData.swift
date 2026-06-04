//
//  GenerateData.swift
//  TemplatePattern
//
//  Created by M on 09.05.2021.
//  Copyright © 2021 M. All rights reserved.
//

import Foundation

class GenerateData {
    static func createFilesWithDataIn() {

        // создаем входной файл для операции транспонирования

        let testArray1 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("transposeIn")

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: testArray1, requiringSecureCoding: false)
            try data.write(to: path)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }

        // создаем входной файл для операции нахождения определителя

        let testArray2 = [[1, 2], [3, 4]]

        path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("determinantIn")

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: testArray2, requiringSecureCoding: false)
            try data.write(to: path)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }

        // создаем входной файл для операции сложения двух матриц

        let testArray3 = [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [[1, 4, 7], [2, 5, 8], [3, 6, 9]]]

        path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("additionIn")

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: testArray3, requiringSecureCoding: false)
            try data.write(to: path)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }

    }
}
