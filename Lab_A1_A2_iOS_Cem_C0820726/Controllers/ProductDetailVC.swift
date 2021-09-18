//
//  ProductDetailVC.swift
//  Lab_A1_A2_iOS_Cem_C0820726
//
//  Created by Cem Safa on 2021-09-18.
//

import UIKit
import CoreData

class ProductDetailVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var providerTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTV.layer.borderColor = UIColor.systemGray5.cgColor
        descriptionTV.layer.borderWidth = 1.0
        descriptionTV.layer.cornerRadius = 8
        nameTF.text = selectedProduct?.productName
        idTF.text = ((selectedProduct?.productId ?? 0) as NSNumber).stringValue
        providerTF.text = selectedProduct?.productProvider
        priceTF.text = ((selectedProduct?.productPrice ?? 0) as NSNumber).stringValue
        descriptionTV.text = selectedProduct?.productDescription
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
