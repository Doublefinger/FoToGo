//
//  FoodSearchViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 11/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import UIKit

class FoodSearchViewController: UITableViewController, UINavigationControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    var foodList = [Food]()
    var filteredList = [Food]()
    let searchController = UISearchController(searchResultsController: nil)
    var searchBarText: String!
    var orderItemIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        foodList.append(Food(category: "American", name: "Roast Beef Sandwich"))
        foodList.append(Food(category: "American", name: "Cheeseburge"))
        foodList.append(Food(category: "Chinese", name: "Orange Chicken"))
        foodList.append(Food(category: "Korean", name: "Bibimbap"))
        foodList.append(Food(category: "Mexican", name: "Burrito"))
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        
        self.navigationController?.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - TableView
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredList.count
        }
        return foodList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodItem", for: indexPath)
        let food: Food
        if searchController.isActive && searchController.searchBar.text != "" {
            food = filteredList[indexPath.row]
        } else {
            food = foodList[indexPath.row]
        }
        cell.textLabel?.text = food.name
        cell.detailTextLabel?.text = food.category
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = foodList[indexPath.row]
        searchController.searchBar.text = food.name
        searchController.dismiss(animated: false, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredList = foodList.filter({ (food) -> Bool in
            return food.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            return
        }
        
        searchController.dismiss(animated: false, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
        //TODO filter dirty words
    }
    
    /*
    // MARK: - Navigation
    */
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? OrderContentTableViewController {
            if searchController.searchBar.text != "" {
                controller.itemIndex = orderItemIndex
                controller.orderItems[orderItemIndex] = searchController.searchBar.text!
                controller.tableView.reloadData()
                controller.newItemFlag = false
            }
        } else {
            searchController.searchBar.text = searchBarText
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
