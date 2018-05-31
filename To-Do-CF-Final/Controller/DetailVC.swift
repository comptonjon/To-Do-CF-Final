//
//  DetailVC.swift
//  To-Do-CF-Final
//
//  Created by Jonathan Compton on 5/27/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import CoreData

class DetailVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var detailTextView: UITextView!
    
    
    let context = TaskData.persistentContainer.viewContext
    var task : Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        detailTextView.delegate = self
        
        if let task = task {
            titleTextView.text = task.title
            detailTextView.text = task.details
        } else {
            titleTextView.text = "Enter Title"
            titleTextView.textColor = UIColor.lightGray
            detailTextView.text = "Enter Details"
            detailTextView.textColor = UIColor.lightGray
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if detailTextView.textColor == UIColor.lightGray {
            detailTextView.text = nil
            detailTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if detailTextView.text.isEmpty {
            detailTextView.text = "Enter Details"
            detailTextView.textColor = UIColor.lightGray
        }
    }

    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        if let task = task {
            task.title = titleTextView.text!
            task.details = detailTextView.text!
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
            let task = Task(entity: entity!, insertInto: context)
            task.title = titleTextView.text!
            task.details = detailTextView.text!
            task.created = NSDate() as Date
            task.isImportant = false
            let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
            do {
                task.rank = Int32(try context.count(for: fetchRequest))
                print(task.rank)
                
            } catch {
                print("Error")
            }
        }
        if let navController = splitViewController?.viewControllers[0] as? UINavigationController {
            navController.popViewController(animated: true)
        }
        
    }
    
    func checkTask(task: Task) {
        if task == self.task {
            self.task = nil
            deleteTitleButtonTapped(self)
            deleteDetailButtonTapped(self)
        }
    }
    @IBAction func deleteTitleButtonTapped(_ sender: Any) {
        titleTextView.text = nil
    }
    @IBAction func deleteDetailButtonTapped(_ sender: Any) {
        detailTextView.text = nil
    }
    
    
}
