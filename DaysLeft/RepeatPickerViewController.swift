//
//  RepeatPickerViewController.swift
//  DaysLeft
//
//  Created by neil on 9/7/17.
//  Copyright © 2017 tdones. All rights reserved.
//

import UIKit

protocol RepeatPickerViewControllerDelegate: class {
    func repeatPicker(picker: RepeatPickerViewController,
                      didPickRepeat repeatType: String)
}

class RepeatPickerViewController: UITableViewController {
    weak var delegate: RepeatPickerViewControllerDelegate?
    
    let repeatTypes = [
                "None",
                "Week",
                "Month",
                "Year"
                ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatTypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatTypeCell", for: indexPath)
        let repeatTypeName = repeatTypes[indexPath.row]
        cell.textLabel!.text = repeatTypeName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let repeatTypeName = repeatTypes[indexPath.row]
            delegate.repeatPicker(picker: self, didPickRepeat: repeatTypeName)
        }
    }
}
