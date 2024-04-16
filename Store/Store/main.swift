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
    private var discountSchemes: [DiscountScheme] = []
    private var finalTotal: Int?

    func addItem(_ item: SKU) {
        itemsScanned.append(item)
    }

    func items() -> [SKU] {
        return itemsScanned
    }

    func total() -> Int {
        return finalTotal ?? items().reduce(0) { $0 + $1.price() }
    }

    func output() -> String {
        let line = "------------------\n"
        var receiptOutput = "Receipt:\n"
        for item in itemsScanned {
            receiptOutput += "\(item.name): $\(String(format: "%.2f", Double(item.price())/100.0))\n"
        }
        receiptOutput += line
        receiptOutput += "TOTAL: $\(String(format: "%.2f", Double(self.total())/100.0))"
        return receiptOutput
    }
    
    func applyDiscountSchemes() -> Int {
        var totalDiscount = 0
        var mutableItems = itemsScanned as! [Item]

        for scheme in discountSchemes {
            totalDiscount += scheme.applyDiscount(items: &mutableItems)
        }

        itemsScanned = mutableItems
        return totalDiscount
    }
    
    func addDiscountScheme(scheme: DiscountScheme) {
        discountSchemes.append(scheme)
    }

    func setFinalTotal(_ total: Int) {
        self.finalTotal = total
    }
}

// Register class modified to handle the discount schemes
class Register {
    private var currentReceipt = Receipt()

    func scan(_ item: SKU) {
        currentReceipt.addItem(item)
    }

    func subtotal() -> Int {
        return currentReceipt.total()
    }

    // Now the total method calculates the final total considering discounts
    func total() -> Receipt {
        let discount = currentReceipt.applyDiscountSchemes()
        let finalTotal = currentReceipt.total() - discount
        currentReceipt.setFinalTotal(finalTotal)
        let finalReceipt = currentReceipt
        currentReceipt = Receipt()
        return finalReceipt
    }

    func addDiscountScheme(scheme: DiscountScheme) {
        currentReceipt.addDiscountScheme(scheme: scheme)
    }
}

// Store class remains the same
class Store {
    let version = "0.1"

    func helloWorld() -> String {
        return "Hello world"
    }
}

// extra credit attempt  2-1

// DiscountScheme protocol
protocol DiscountScheme {
    func applyDiscount(items: inout [Item]) -> Int
}

class TwoForOnePricingScheme: DiscountScheme {
    private let qualifyingItemName: String
    private var qualifyingItemCount: Int = 0

    init(qualifyingItemName: String) {
        self.qualifyingItemName = qualifyingItemName
    }

    func applyDiscount(items: inout [Item]) -> Int {
        let eligibleItems = items.filter { $0.name == self.qualifyingItemName }
        qualifyingItemCount += eligibleItems.count

        // Every third item is free
        let discountCount = qualifyingItemCount / 3
        qualifyingItemCount -= discountCount * 3 

        let discount = eligibleItems.first?.price() ?? 0
        return discountCount * discount
    }
}
