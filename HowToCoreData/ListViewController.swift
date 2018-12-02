//
//  ListViewController.swift
//  HowToCoreData
//
//  Created by Guadalupe Vlcek on 01/12/2018.
//  Copyright © 2018 Guadalupe Vlček. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var selectedList:List?
    
    var fetchedResultsController:NSFetchedResultsController<List>!
    var moc:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        setupFetchedResultsController()
    }
    
    func setupFetchedResultsController () {
        let listRequest:NSFetchRequest<List> = List.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        listRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: listRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch{
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListDetail" {
            if let destination = segue.destination as? DetailViewController {
                guard let list = selectedList else { return }
                destination.list = list
            }
        }
    }
    
    @IBAction func plusTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Agregar Lista", message: "Ingresar nombre de listado", preferredStyle: .alert)
        
        alertController.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Nueva lista"
        }
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
            let textfield = alertController.textFields?.first
            
            let listObject = List(context: self.moc)
            listObject.name = textfield?.text
            listObject.created = Date()
            
            do {
                try self.moc.save()
                self.setupFetchedResultsController()
                self.tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listObject = fetchedResultsController.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = listObject.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedList = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "ListDetail", sender: navigationController)
    }
}
