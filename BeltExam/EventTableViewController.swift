//
//  ViewController.swift
//  BeltExam
//
//  Created by Chao-I Chen on 1/27/18.
//  Copyright © 2018 Chao-I Chen. All rights reserved.
//

import UIKit
import CoreData

class EventTableViewController: UITableViewController, EventDelegate {
    var header = ["Incomplete","Complete"]
    var incompleteEvents: [Event] = []
    var completeEvents: [Event] = []
    var allEvents: [[Event]] = []
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? MyEvent {
            let indexPath = tableView.indexPath(for: cell)
            performSegue(withIdentifier: "Add", sender: indexPath)
        }
    }
    
    func itemSaved(by controller: AddEventViewController, with text: String, with info: String, and date: Date, and index: IndexPath?){
        if let idx = index {
            let cell = allEvents[idx.section][idx.row]
            cell.title = text
            cell.info = info
            cell.date = date
        }else{
            let newItem = NSEntityDescription.insertNewObject(forEntityName: "Event", into: managedObjectContext) as! Event
            newItem.title = text
            newItem.info = info
            newItem.date = date
            newItem.complete = false
        }
        
        do{
            try managedObjectContext.save()
        }catch{
            print(error)
        }
        fetchAll()
        
        dismiss(animated: true, completion: nil)
    }
    
    func itemCancle(by controller: AddEventViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AddEventViewController
        destination.delegate = self
        
        if let indexPath = sender as? IndexPath {
            let event = allEvents[indexPath.section][indexPath.row]
            destination.timeDate = event.date
            destination.titleString = event.title
            destination.infoString = event.info
            destination.index = indexPath
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyEvent
        let formatter = DateFormatter()
        
        let current_event = allEvents[indexPath.section][indexPath.row]
        formatter.dateFormat = "hh:mm a"
        cell.titleLabel?.text = current_event.title
        cell.timeLabel?.text = formatter.string(from: current_event.date!)
        
        cell.editButton.isHidden = indexPath.section == 1
        //the 2nd half will return true or false

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEvents[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return header.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = allEvents[indexPath.section][indexPath.row]
        
        event.complete = !event.complete
        
        do{
            try managedObjectContext.save()
        }catch{
            print(error)
        }
        fetchAll()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete"){(action, indexPath) in
            
            let event = self.allEvents[indexPath.section][indexPath.row]
            self.allEvents[indexPath.section].remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.managedObjectContext.delete(event)
            do{
                try self.managedObjectContext.save()
            }catch{
                print(error)
            }
        }
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return [deleteAction]
    }
    
    func fetchAll(){
        completeEvents.removeAll()
        incompleteEvents.removeAll()
        allEvents.removeAll()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        
        do{
            let result = try managedObjectContext.fetch(request) as! [Event]
            for event in result{
                if event.complete == false{
                    incompleteEvents.append(event)
                }else{
                    completeEvents.append(event)
                }
            }
            completeEvents.sort(by: {$0.date! < $1.date!})
            incompleteEvents.sort(by: {$0.date! < $1.date!})
            allEvents.append(incompleteEvents)
            allEvents.append(completeEvents)
            
            tableView.reloadData()
        }catch{
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
