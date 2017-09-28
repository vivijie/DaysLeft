//
//  AddBigDayViewController.swift
//  DaysLeft
//
//  Created by neil on 9/6/17.
//  Copyright © 2017 tdones. All rights reserved.
//

import UIKit
import CoreData


protocol AddBigDayViewControllerDelegate: class {
    func addBigDayViewControllerDidCancel(controller: AddBigDayViewController)
    func addBigDayViewController(controller: AddBigDayViewController, didFinishEditingItem item: BigDay)
    func addBigDayViewController(controller: AddBigDayViewController, title: String, date: Date, repeat_type: String)
}

class AddBigDayViewController: UITableViewController, UITextFieldDelegate, RepeatPickerViewControllerDelegate {
    
    
    @IBOutlet weak var repeatTypeName: UILabel!
    
    var itemToEdit: BigDay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "EDIT DAY"
            textField.text = item.title
            repeatTypeName.text = item.repeat_type
            dueDate = item.big_date!
            doneBarButton.isEnabled = true
        } else {
          textField.becomeFirstResponder()
          repeatTypeName.text = "None"
          dueDate = Date()
      }
    }
    
    @IBAction func cancel() {
        delegate?.addBigDayViewControllerDidCancel(controller: self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.title = textField.text!
            item.big_date = Date()
            item.repeat_type = repeatTypeName.text
            item.big_date = dueDate
            item.day_description = "On"
            delegate?.addBigDayViewController(controller: self, didFinishEditingItem: item)
        } else {
            let titleToAdd = textField.text!
            let big_date = dueDate
            let repeat_type = repeatTypeName.text
            delegate?.addBigDayViewController(controller: self, title: titleToAdd, date: big_date, repeat_type: repeat_type!)
        }
    }
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: AddBigDayViewControllerDelegate?
  
  // To disable row select
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 || indexPath.section == 2 {
            return indexPath
        } else {
            return nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString as NSString
        
        
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    // Repeat Picker
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickRepeatType" {
            let controller = segue.destination as! RepeatPickerViewController
            controller.delegate = self
        }
    }
    
    func repeatPicker(picker: RepeatPickerViewController, didPickRepeat repeatType: String) {
        repeatTypeName.text = repeatType
        navigationController?.popViewController(animated: true)
    }
    
    // Date Picker
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var bigDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(datePicker: UIDatePicker) {
        dueDate = datePicker.date
    }
    
    @IBAction func tapRemindSwitch(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    
    var dueDate = Date() {
        didSet {
            updateBigDateLabel()
        }
    }
    var datePickerVisible = false
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        textField.resignFirstResponder()
        
        if indexPath.section == 2 && indexPath.row == 0 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false

            let indexPathDatePicker = NSIndexPath(row: 2, section: 2)
            
            tableView.deleteRows(at: [indexPathDatePicker as IndexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func showDatePicker() {
        datePickerVisible = true
        
        let indexPathDatePicker = NSIndexPath(row: 2, section: 2)
        
        tableView.insertRows(at: [indexPathDatePicker as IndexPath], with: .fade)
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    func updateBigDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        bigDateLabel.text = formatter.string(from: dueDate)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var indexPath = indexPath
        if indexPath.section == 2 && indexPath.row == 2 {
            indexPath = NSIndexPath(row: 0, section: indexPath.section) as IndexPath
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
}
