//
//  FoodSearchViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 11/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import UIKit

class FoodSearchViewController: UITableViewController, UINavigationControllerDelegate, UISearchResultsUpdating {
    var foodList = [Food]()
    var filteredList = [Food]()
    let searchController = UISearchController(searchResultsController: nil)
    
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
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredList = foodList.filter({ (food) -> Bool in
            return food.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
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
