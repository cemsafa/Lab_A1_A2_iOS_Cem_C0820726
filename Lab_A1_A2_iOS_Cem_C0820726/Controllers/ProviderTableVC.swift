//
//  ProviderTableVC.swift
//  Lab_A1_A2_iOS_Cem_C0820726
//
//  Created by Cem Safa on 2021-09-19.
//

import UIKit
import CoreData

class ProviderTableVC: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var products = [Product]()
    
    var selectedProvider: Provider? {
        didSet {
            loadProducts()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selectedProvider?.products?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "providerCell", for: indexPath)
        cell.textLabel?.text = products[indexPath.row].productName
        return cell
    }
    
    // MARK: - Private methods
    
    private func loadProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            products = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }

}
