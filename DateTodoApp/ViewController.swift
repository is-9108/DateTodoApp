//
//  ViewController.swift
//  DateTodoApp
//
//  Created by Shota Ishii on 2020/04/06.
//  Copyright © 2020 is. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var selectDay = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.dataSource = self
        self.calendar.delegate = self
    }
    
    fileprivate let gregoriam: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func judgeHoliday(_ date:Date) -> Bool{
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if self.judgeHoliday(date){
            return UIColor.red
        }
            let weekday = self.getWeekIdx(date)
            if weekday == 1{
                return UIColor.red
            }else if weekday == 7{
                return UIColor.blue
            }
            
            return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let tmpDate = Calendar(identifier: .gregorian)
               
               let month = tmpDate.component(.month, from: date)
               let day = tmpDate.component(.day, from: date)
               
               let m = String(format: "%02d", month)
               let d = String(format: "%02d", day)
        selectDay = "\(m)/\(d)"
        performSegue(withIdentifier: "table", sender: nil)
    }
    
    func setSelectDay(string:String){
        selectDay = string
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let table = segue.destination as! TableViewController
        setSelectDay(string: selectDay)
        table.selectDay = selectDay
    }

}

