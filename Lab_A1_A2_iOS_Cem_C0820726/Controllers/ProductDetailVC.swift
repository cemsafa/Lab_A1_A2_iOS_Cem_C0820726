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
    @IBOutlet weak var navBar: UINavigationBar!
    
    weak var delegate: MainVC?
    
    var navBarIsHidden: Bool?
    
    var editMode = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var providers: [Provider]?
    
    var selectedProduct: Product? {
        didSet {
            editMode = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTV.layer.borderColor = UIColor.systemGray5.cgColor
        descriptionTV.layer.borderWidth = 1.0
        descriptionTV.layer.cornerRadius = 8
        
        if navBarIsHidden != nil {
            navBar.isHidden = navBarIsHidden!
        }
        
        
        if editMode {
            nameTF.text = selectedProduct?.productName
            idTF.text = ((selectedProduct?.productId ?? 0) as NSNumber).stringValue
            providerTF.text = selectedProduct?.productProvider
            priceTF.text = ((selectedProduct?.productPrice ?? 0) as NSNumber).stringValue
            descriptionTV.text = selectedProduct?.productDescription
//            selectedProduct?.parentProvider = provider
//            provider?.name = providerTF.text
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if editMode {
            delegate?.deleteProduct(selectedProduct!)
        } else {
            return
        }
        guard nameTF.text != nil, idTF.text != nil, providerTF.text != nil, priceTF.text != nil, descriptionTV.text != nil else { return }
        delegate?.updateProduct(name: nameTF.text, description: descriptionTV.text, id: Int16(idTF.text!), price: Double(priceTF.text!), provider: providerTF.text)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Private methods
    
    private func loadProviders(with predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
//        let predicate = NSPredicate(format: "NOT name MATCHES %@", selectedProduct?.parentProvider?.name ?? "")
//        request.predicate = predicate
        do {
            providers = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        if !editMode {
            let newProduct = Product(context: context)
            newProduct.productName = nameTF.text
            newProduct.productId = Int16(idTF.text ?? "") ?? 0
            newProduct.productPrice = Double(priceTF.text ?? "") ?? 0
            newProduct.productProvider = providerTF.text
            newProduct.productDescription = descriptionTV.text
            
            let request: NSFetchRequest<Provider> = Provider.fetchRequest()
            request.predicate = NSPredicate(format: "name=%@", providerTF.text!)
            do {
                let results = try context.fetch(request)
                if results.count != 0 {
                    let currentProvider = results[0]
                    currentProvider.addToProducts(newProduct)
                } else {
                    newProduct.parentProvider?.name = providerTF.text
                    let newProvider = Provider(context: context)
                    newProvider.name = providerTF.text
                    newProvider.products = NSSet(array: [newProduct])
                }
            } catch {
                print(error.localizedDescription)
            }
            
            performSegue(withIdentifier: "dismissProductDetailVC", sender: self)
            dismiss(animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
    }
    
}
