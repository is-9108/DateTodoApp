//
//  TableViewController.swift
//  DateTodoApp
//
//  Created by Shota Ishii on 2020/04/06.
//  Copyright © 2020 is. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectDay = ""
    
    var task = Task()
    let realm = try! Realm()
    
    var allTask = try! Realm().objects(Task.self).sorted(byKeyPath: "hour")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dateLabel.text = selectDay
        print(allTask)
        allTask = try! realm.objects(Task.self).filter("date == %@","\(selectDay)")
        print(allTask)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let Add:AddViewController = segue.destination as! AddViewController
        if segue.identifier == "cellSegue"{
            let indexPath = self.tableView.indexPathForSelectedRow
            Add.task = allTask[indexPath!.row]
            print(allTask[indexPath!.row])
        }else{
            let task = Task()

            let allTask = realm.objects(Task.self)
        
            if allTask.count != 0{
                task.id = allTask.max(ofProperty: "id")! + 1
            }
            Add.task = task
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        let task = allTask[indexPath.row]
        
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let task = allTask[indexPath.row]
            
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
        
        try! realm.write {
            self.realm.delete(task)
            tableView.deleteRows(at: [indexPath], with: .fade)
            }
            center.getPendingNotificationRequests{(requests: [UNNotificationRequest]) in
                for request in requests{
                    print("-----------")
                    print(request)
                    print("-----------")

                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   

}
