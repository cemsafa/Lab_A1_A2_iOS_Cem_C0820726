//
//  ProductDemo.swift
//  Lab_A1_A2_iOS_Cem_C0820726
//
//  Created by Cem Safa on 2021-09-18.
//

import Foundation

struct ProductDemo {
    
    let productId: Int16
    let productName: String
    let productDesription: String
    let productPrice: Double
    let productProvider: String
    
    init(productId: Int16, productName: String, productDesription: String, productPrice: Double, productProvider: String) {
        self.productId = productId
        self.productName = productName
        self.productDesription = productDesription
        self.productPrice = productPrice
        self.productProvider = productProvider
    }
    
}
