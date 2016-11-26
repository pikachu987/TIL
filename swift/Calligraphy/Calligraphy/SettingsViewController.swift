//
//  SettingsViewController.swift
//  Calligraphy
//
//  Created by guanho on 2016. 11. 24..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import EventKit

class SettingsViewController: UITableViewController {
    @IBOutlet var alarmSwitch: UISwitch!
    @IBOutlet var datepicker: UIDatePicker!
    
    var eventStore: EKEventStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveBtn: UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.saveSetting))
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    func saveSetting(){
        if self.eventStore == nil{
            self.eventStore = EKEventStore()
            self.eventStore!.requestAccess(to: EKEntityType.reminder, completion: { (isAccessible, errors) in
                let predicateForEvents: NSPredicate = self.eventStore!.predicateForReminders(in: [self.eventStore!.defaultCalendarForNewReminders()])
                
                self.eventStore!.fetchReminders(matching: predicateForEvents, completion: { (reminders) in
                    for reminder in reminders!{
                        if reminder.title == "Calli Alarm"{
                            do{
                                try self.eventStore!.remove(reminder, commit: true)
                            }catch{
                                
                            }
                        }
                    }
                })
                
                if self.alarmSwitch.isOn{
                    let reminder = EKReminder(eventStore: self.eventStore!)
                    reminder.title = "Calli Alarm"
                    reminder.calendar = self.eventStore!.defaultCalendarForNewReminders()
                    
                    let alarm = EKAlarm(absoluteDate: self.datepicker.date)
                    reminder.addAlarm(alarm)
                    
                    do{
                        try self.eventStore!.save(reminder, commit: true)
                    }catch{
                        NSLog("알람 설정 실패")
                    }
                }
            })
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let currendDate = Date()
        self.datepicker.minimumDate = currendDate
    }
}
