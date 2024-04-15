//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int
}

class Item: SKU {
    var name: String
    private var itemPriceEach: Int

    init(name: String, priceEach: Int) {
        self.name = name
        self.itemPriceEach = priceEach
    }

    func price() -> Int {
        return itemPriceEach
    }
}

class Receipt {
    private var itemsScanned: [SKU] = []

    func addItem(_ item: SKU) {
        itemsScanned.append(item)
    }

    func items() -> [SKU] {
        return itemsScanned
    }

    func total() -> Int {
        return items().reduce(0) { $0 + $1.price() }
    }

    func output() -> String {
        let line = "------------------\n"
        var receiptOutput = "Receipt:\n"
        for item in itemsScanned {
            receiptOutput += "\(item.name): $\(String(format: "%.2f", Double(item.price())/100.0))\n"
        }
        receiptOutput += line
        receiptOutput += "TOTAL: $\(String(format: "%.2f", Double(total())/100.0))"
        return receiptOutput
    }
}

class Register {
    private var currentReceipt = Receipt()

    func scan(_ item: SKU) {
        currentReceipt.addItem(item)
    }

    func subtotal() -> Int {
        return currentReceipt.total()
    }

    func total() -> Receipt {
        let finalReceipt = currentReceipt
        currentReceipt = Receipt()
        return finalReceipt
    }
}

class Store {
    let version = "0.1"

    func helloWorld() -> String {
        return "Hello world"
    }
}


