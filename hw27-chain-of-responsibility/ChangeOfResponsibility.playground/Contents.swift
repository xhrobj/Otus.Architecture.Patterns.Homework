import Foundation

typealias Path = String

protocol FileHandler {
    func setNext(_ handler: FileHandler)
    func handle(file: Path)
}

class BaseFileHandler: FileHandler {
    private var next: FileHandler?

    func setNext(_ handler: FileHandler) {
        next = handler
    }

    func handle(file: Path) {
        guard let next = next else {
            print("!!! файл не был распознан ни одним из обрабочиков и был пропущен\n")
            return
        }
        next.handle(file: file)
    }

    func fileExtension(_ file: Path) -> String {
        URL(fileURLWithPath: file).pathExtension.lowercased()
    }
}

class XMLFileHandler: BaseFileHandler {
    override func handle(file: Path) {
        guard isXMLFile(file) else {
            super.handle(file: file)
            return
        }

        print("-> файл распознан как <XML> и будет обработан соответсвующим образом\n")

        // NOTE: обработка <XML> файла ...
    }

    private func isXMLFile(_ file: Path) -> Bool {
        fileExtension(file) == "xml"
    }
}

class JSONFileHandler: BaseFileHandler {
    override func handle(file: Path) {
        guard isJSONFile(file) else {
            super.handle(file: file)
            return
        }

        print("-> файл распознан как {JSON} и будет обработан соответсвующим образом\n")

        // NOTE: обработка {JSON} файла ...
    }

    private func isJSONFile(_ file: Path) -> Bool {
        fileExtension(file) == "json"
    }
}

class CSVFileHandler: BaseFileHandler {
    override func handle(file: Path) {
        guard isCSVFile(file) else {
            super.handle(file: file)
            return
        }

        print("-> файл распознан как [CSV] и будет обработан соответсвующим образом\n")

        // NOTE: обработка [CSV] файла ...
    }

    private func isCSVFile(_ file: Path) -> Bool {
        fileExtension(file) == "csv"
    }
}

class TXTFileHandler: BaseFileHandler {
    override func handle(file: Path) {
        guard isTXTFile(file) else {
            super.handle(file: file)
            return
        }

        print("-> файл распознан как *TXT* и будет обработан соответсвующим образом\n")

        // NOTE: обработка *TXT* файла ...
    }

    private func isTXTFile(_ file: Path) -> Bool {
        fileExtension(file) == "txt"
    }
}

// 1. создаем обработчики файлов нужного типа
let xmlFileHandler = XMLFileHandler()
let jsonFileHandler = JSONFileHandler()
let csvFileHandler = CSVFileHandler()
let txtFileHandler = TXTFileHandler()

// 2. объединяем обработчики в цепочку: xml -> json -> csv -> txt
xmlFileHandler.setNext(jsonFileHandler)
jsonFileHandler.setNext(csvFileHandler)
csvFileHandler.setNext(txtFileHandler)

// 3. список тестовых файлов
let files = ["xxx.json", "yyy.svc", "yyy.csv", "zzz.txt", "aaa.xml", "bbb.log", "ccc.json", "ddd"]

// 4. каждый из файлов списка подаем на вход цепочки,
// если один из обработчиков в цепочке распознает его как "свой" файл,
// он его обработает и остановит прохождение этого файла по цепочке
for file in files {
    print("файл \(file) передан на вход цепочке" )
    xmlFileHandler.handle(file: file)
}
