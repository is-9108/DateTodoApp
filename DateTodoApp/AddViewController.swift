//
//  AddViewController.swift
//  DateTodoApp
//
//  Created by Shota Ishii on 2020/04/06.
//  Copyright © 2020 is. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var task :Task!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTextView.layer.borderColor = UIColor.gray.cgColor
        memoTextView.layer.borderWidth = 1.0
        memoTextView.layer.cornerRadius = 10.0
        memoTextView.layer.masksToBounds = true
        
        titleTextField.text = task.title
        memoTextView.text = task.memo
        datePicker.date = task.timer
    }
    

    @IBAction func add(_ sender: Any) {
        try! realm.write {
            self.task.title = titleTextField.text!
            self.task.memo = memoTextView.text
            self.task.timer = datePicker.date
            
            let dayFormat = DateFormatter()
            dayFormat.dateFormat = "MM/dd"
            self.task.date = dayFormat.string(from: datePicker.date)
            
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "HH:mm"
            self.task.time = timeFormat.string(from: datePicker.date)
            
            let hourFormat = DateFormatter()
            hourFormat.dateFormat = "HH"
            self.task.hour = Int(hourFormat.string(from: datePicker.date))!
            
            realm.add(self.task,update: .modified)
            print(task)
        }
        setNotification(task: task)
        dismiss(animated: true, completion: nil)
    }
    
    func setNotification(task:Task){
        let content = UNMutableNotificationContent()
        if task.title == ""{
            content.title = "(タイトルなし)"
        }else{
            content.title = task.title
        }
        if task.memo == ""{
            content.body = "(内容なし)"
        }else{
            content.body = task.memo
        }
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let timer:Date = Calendar.current.date(byAdding: .day, value: -1, to: task.timer)!
        print(timer)
        let dateComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: timer)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request){ (error) in
            print(error ?? "ローカル通知登録 OK")
        }
        
        center.getPendingNotificationRequests{(requests:[UNNotificationRequest]) in
            for request in requests{
                print("-----------")
                print(request)
                print("-----------")
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.titleTextField.endEditing(true)
        self.memoTextView.endEditing(true)
    }
    
    @IBAction func bsck(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
