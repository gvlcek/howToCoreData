//
//  DetailViewController.swift
//  HowToCoreData
//
//  Created by Guadalupe Vlcek on 02/12/2018.
//  Copyright © 2018 Guadalupe Vlček. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemNavigation: UINavigationItem!
    
    var moc:NSManagedObjectContext!
    var list:List?
    var itemsArray:[ListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        loadArray()
        itemNavigation.title = list?.name
    }
    
    func loadArray() {
        itemsArray = []
        guard let listItem = list else { return }
        if let itemList = listItem.listItem as? Set<ListItem> {
            
            let sortedArray = itemList.sorted(by: { (itemA:ListItem, itemB:ListItem) -> Bool in
                #warning("Avoid force unwrapping")
                return itemA.created!.compare(itemB.created!) == ComparisonResult.orderedAscending
            })
            
            for item in sortedArray {
                itemsArray.append(item)
            }
        }
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Agregar Item", message: "Ingrese un nombre", preferredStyle: .alert)
        
        alertController.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Nuevo Item"
        }
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
            let textfield = alertController.textFields?.first
            
            let itemObject = ListItem(context: self.moc)
            itemObject.name = textfield?.text
            itemObject.checked = false
            itemObject.created = Date()
            itemObject.list?.items = 5
            
            self.list?.addToListItem(itemObject)
            
            do {
                try self.moc.save()
                self.loadArray()
                self.tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.listItem?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailTableViewCell
        cell.setupCell(name: itemsArray[indexPath.row].name ?? "")        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemObject = itemsArray[indexPath.row]
            itemObject.managedObjectContext?.delete(itemObject)
            do {
                try self.moc.save()
                self.loadArray()
                self.tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
