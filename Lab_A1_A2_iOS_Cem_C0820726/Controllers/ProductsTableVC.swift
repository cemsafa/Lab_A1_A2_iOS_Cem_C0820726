//
//  ProductsTableVC.swift
//  Lab_A1_A2_iOS_Cem_C0820726
//
//  Created by Cem Safa on 2021-09-18.
//

import UIKit
import CoreData

class ProductsTableVC: UITableViewController {
    
    var products = [Product]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadProducts()
        showSearchBar()
        if products == [] {
            let exampleProducts = [
                ProductDemo(productId: 1, productName: "pen", productDesription: "blue ink", productPrice: 0.80, productProvider: "BIC"),
                ProductDemo(productId: 3, productName: "laptop", productDesription: "work laptop", productPrice: 999.99, productProvider: "HP"),
                ProductDemo(productId: 5, productName: "cell phone", productDesription: "most advance phone ever", productPrice: 1099.50, productProvider: "Apple"),
                ProductDemo(productId: 2, productName: "freezer", productDesription: "freezing cold food storage", productPrice: 510.49, productProvider: "Electrolux"),
                ProductDemo(productId: 8, productName: "tv", productDesription: "led ambilight", productPrice: 899, productProvider: "LG"),
                ProductDemo(productId: 10, productName: "game console", productDesription: "playstation 5", productPrice: 499, productProvider: "Sony"),
                ProductDemo(productId: 42, productName: "table", productDesription: "100x200 dining table", productPrice: 0.80, productProvider: "Ikea"),
                ProductDemo(productId: 11, productName: "chair", productDesription: "office chair", productPrice: 0.80, productProvider: "Ikea"),
                ProductDemo(productId: 9, productName: "couch", productDesription: "comfortable", productPrice: 0.80, productProvider: "Structube"),
                ProductDemo(productId: 6, productName: "desk", productDesription: "office desk", productPrice: 0.80, productProvider: "Ikea")
            ]
            for product in exampleProducts {
                let newProduct = Product(context: context)
                newProduct.productId = product.productId
                newProduct.productName = product.productName
                newProduct.productDescription = product.productDesription
                newProduct.productPrice = product.productPrice
                newProduct.productProvider = product.productProvider
                products.append(newProduct)
                saveProduct()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        cell.textLabel?.text = products[indexPath.row].productName
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ProductDetailVC {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedProduct = products[indexPath.row]
            }
        }
    }
    
    private func loadProducts(with predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "productName", ascending: true)]
        
        if predicate != nil {
            request.predicate = predicate
        }
        
        do {
            products = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }

    
    private func saveProduct() {
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func showSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search product"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

}

// MARK: - UISearchBarDelegate

extension ProductsTableVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let namePredicate = NSPredicate(format: "productName CONTAINS[cd] %@", searchBar.text!)
        let descriptionPredicate = NSPredicate(format: "productDescription CONTAINS[cd] %@", searchBar.text!)
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [namePredicate, descriptionPredicate])
        loadProducts(with: predicate)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadProducts()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadProducts()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
