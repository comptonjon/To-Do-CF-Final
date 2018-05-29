//
//  MasterVC.swift
//  To-Do-CF-Final
//
//  Created by Jonathan Compton on 5/27/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import CoreData

class MasterVC: UIViewController {

    let context = TaskData.persistentContainer.viewContext
    var tasks = [Task]()
    var frc : NSFetchedResultsController<Task>?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        segmentControlValueChange(self)
        
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
    }
    
    func fetchAndLoadData(sortDescriptor: NSSortDescriptor){
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.sortDescriptors = [sortDescriptor]
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc?.delegate = self
        do {
            try frc?.performFetch()
        } catch {
            print("Error fetching")
        }
        tableView.reloadData()  
    }
    @IBAction func segmentControlValueChange(_ sender: Any) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            fetchAndLoadData(sortDescriptor: NSSortDescriptor(key: "created", ascending: true))
        }
        if segmentedControl.selectedSegmentIndex == 1 {
            fetchAndLoadData(sortDescriptor: NSSortDescriptor(key: "rank", ascending: true))
        }
        if segmentedControl.selectedSegmentIndex == 2 {
            fetchAndLoadData(sortDescriptor: NSSortDescriptor(key: "title", ascending: true))
        }
    }
}

extension MasterVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionInfo = frc?.sections?[section] else {
            fatalError("Failed to load fetched results controller")
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let frc = frc else {
            fatalError("Failed to load fetched results controller")
        }
        
        let task = frc.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = task.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let frc = frc else {
            fatalError("Failed to load fetched results controller")
        }
        let task = frc.object(at: sourceIndexPath)
        var taskArray : [Task] = frc.fetchedObjects!
        taskArray.remove(at: sourceIndexPath.row)
        taskArray.insert(task, at: destinationIndexPath.row)
        var i : Int32 = 1
        for task in taskArray {
            task.rank = i
            i += 1
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let frc = frc else {
            fatalError("Failed to load fetched results controller")
        }
        let object = frc.object(at: indexPath)
        context.delete(object)
    }
}

extension MasterVC : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ control: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {
                fatalError("New index path is nil")
            }
            
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {
                fatalError("Index path is nil")
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let newIndexPath = newIndexPath,
                let indexPath = indexPath else {
                    fatalError("Index path or new index path is nil?")
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else {
                fatalError("Index path is nil")
            }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        TaskData.saveContext()
    }
}

