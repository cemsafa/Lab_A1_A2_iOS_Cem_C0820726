//
//  MainVC.swift
//  Lab_A1_A2_iOS_Cem_C0820726
//
//  Created by Cem Safa on 2021-09-18.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var switchBtn: UIBarButtonItem!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var products = [Product]()
    var providers = [Provider]()
    
    var isProduct = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showSearchBar()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        loadUI("Products", "Providers")
        loadProducts()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgToProduct" {
            if let destinationVC = segue.destination as? ProductDetailVC {
                destinationVC.navBarIsHidden = true
                destinationVC.delegate = self
                if let indexPath = mainTableView.indexPathForSelectedRow {
                    destinationVC.selectedProduct = products[indexPath.row]
                    destinationVC.providers = providers
                }
            }
        }
        
        if segue.identifier == "sgToProvider" {
            if let destinationVC = segue.destination as? ProviderTableVC {
                if let indexPath = mainTableView.indexPathForSelectedRow {
                    destinationVC.selectedProvider = providers[indexPath.row]
                }
            }
        }
    }
    
    @IBAction func unwindToMainVC(_ unwindSegue: UIStoryboardSegue) {
        saveProducts()
        saveProviders()
        loadProducts()
        loadProviders()
    }
    
    // MARK: - Public methods
    
    func updateProduct(name: String?, description: String? = nil, id: Int16? = nil, price: Double? = nil, provider: String? = nil) {
        products = []
        let newProduct = Product(context: context)
        newProduct.productName = name
        newProduct.productDescription = description
        newProduct.productId = id ?? 0
        newProduct.productPrice = price ?? 0
        newProduct.productProvider = provider
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
        request.predicate = NSPredicate(format: "name=%@", provider!)
        do {
            let results = try context.fetch(request)
            if results.count != 0 {
                let currentProvider = results[0]
                currentProvider.addToProducts(newProduct)
            } else {
                newProduct.parentProvider?.name = provider
                let newProvider = Provider(context: context)
                newProvider.name = provider
                newProvider.products = NSSet(array: [newProduct])
            }
        } catch {
            print(error.localizedDescription)
        }
        saveProducts()
        loadProducts()
    }
    
    func deleteProduct(_ product: Product) {
        context.delete(product)
    }
    
    func deleteProvider(_ provider: Provider) {
        context.delete(provider)
    }
    
    // MARK: - Private methods
    
    private func loadUI(_ var1: String, _ var2: String) {
        title = var1
        switchBtn.title = "Show \(var2)"
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
        mainTableView.reloadData()
    }
    
    private func loadProviders(with predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if predicate != nil {
            request.predicate = predicate
        }
        
        do {
            providers = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        mainTableView.reloadData()
    }
    
    private func saveProducts() {
        do {
            try context.save()
            mainTableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveProviders() {
        do {
            try context.save()
            mainTableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func showSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - IBAction
    
    @IBAction func switchBtnPressed(_ sender: UIBarButtonItem) {
        isProduct = !isProduct
        if isProduct {
            loadUI("Products", "Providers")
            loadProducts()
        } else {
            loadUI("Providers", "Products")
            loadProviders()
        }
        mainTableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isProduct ? products.count : providers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
        if isProduct {
            cell.textLabel?.text = products[indexPath.row].productName
            cell.detailTextLabel?.text = products[indexPath.row].productProvider
            cell.imageView?.image = nil
        } else {
            cell.textLabel?.text = providers[indexPath.row].name
            cell.detailTextLabel?.text = "\(providers[indexPath.row].products?.count ?? 0)"
            cell.imageView?.image = UIImage(systemName: "folder")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isProduct {
            performSegue(withIdentifier: "sgToProduct", sender: self)
        } else {
            performSegue(withIdentifier: "sgToProvider", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isProduct {
                deleteProduct(products[indexPath.row])
                saveProducts()
                products.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                deleteProvider(providers[indexPath.row])
                saveProviders()
                providers.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}

// MARK: - UISearchBarDelegate

extension MainVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if isProduct {
            let predicate = NSPredicate(format: "productName CONTAINS[cd] %@", searchBar.text!)
            loadProducts(with: predicate)
        } else {
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
            loadProviders(with: predicate)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if isProduct {
            loadProducts()
        } else {
            loadProviders()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if isProduct {
            if searchBar.text?.count == 0 {
                loadProducts()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        } else {
            if searchBar.text?.count == 0 {
                loadProviders()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
    }
}
