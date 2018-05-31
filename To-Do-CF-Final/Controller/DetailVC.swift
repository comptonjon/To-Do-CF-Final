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
    @IBOutlet weak var clearTitleButton: UIButton!
    @IBOutlet weak var clearDetailButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    let context = TaskData.persistentContainer.viewContext
    var task : Task?
    var canSave = false

    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.delegate = self
        detailTextView.delegate = self
        clearTitleButton.alpha = 0
        clearDetailButton.alpha = 0
        
        if let task = task {
            titleTextView.text = task.title
            detailTextView.text = task.details
            clearTitleButton.alpha = 1.0
            clearDetailButton.alpha = 1.0
            
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
        if titleTextView.textColor == UIColor.lightGray {
            titleTextView.text = nil
            titleTextView.textColor = UIColor.black
        }

        UIView.animate(withDuration: 0.4) {
            self.clearTitleButton.alpha = 1.0
            self.clearDetailButton.alpha = 1.0
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if detailTextView.text.isEmpty {
            detailTextView.text = "Enter Details"
            detailTextView.textColor = UIColor.lightGray
        }
        if titleTextView.text.isEmpty {
            titleTextView.text = "Enter Title"
            titleTextView.textColor = UIColor.lightGray
        }
        if detailTextView.text.isEmpty && titleTextView.text.isEmpty {
            UIView.animate(withDuration: 0.4) {
                self.clearTitleButton.alpha = 0.0
                self.clearDetailButton.alpha = 0.0
            }
        }
    }

    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        if let task = task {
            task.title = titleTextView.text!
            task.details = detailTextView.text!
        } else if detailTextView.text == nil || titleTextView.text == nil || (titleTextView.textColor == UIColor.lightGray && titleTextView.textColor == UIColor.lightGray){
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
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
