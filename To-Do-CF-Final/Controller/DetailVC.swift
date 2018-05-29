//
//  DetailVC.swift
//  To-Do-CF-Final
//
//  Created by Jonathan Compton on 5/27/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import CoreData

class DetailVC: UIViewController {
    
    @IBOutlet weak var titleTextField : UITextField!
    @IBOutlet weak var detailTextField : UITextField!
    
    let context = TaskData.persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let task = Task(entity: entity!, insertInto: context)
        task.title = titleTextField.text!
        task.details = detailTextField.text!
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
    
}
