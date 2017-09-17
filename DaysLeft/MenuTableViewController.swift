//
//  MenuTableViewController.swift
//  DaysLeft
//
//  Created by viviJIE on 9/17/17.
//  Copyright © 2017 tdones. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class MenuTableViewController: UITableViewController {

  @IBAction func done(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBOutlet weak var versionLabel: UILabel!
  
  let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 44
    updateUI()
    }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.section == 0 && indexPath.row == 0 {
      launchEmail()
    } else if indexPath.section == 0 && indexPath.row == 1 {
      
    }
  }
  
  private func updateUI() {
    versionLabel.text = version
  }
  
  func launchEmail() {
    let iOSVersion = UIDevice.current.systemVersion
    let model = UIDevice.current.model

    
    let recipients = ["brincells@gmail.com"]
    let subject = "Days v\(version) Support"
    let supportText = "Please write your feedback here.\n\n\n\n"
    let supportBody = supportText + "iOS Version: \(iOSVersion)\nDevice: \(model)"
    
    let mailComposer: MFMailComposeViewController = MFMailComposeViewController()
    mailComposer.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
    mailComposer.setToRecipients(recipients)
    mailComposer.setSubject(subject)
    mailComposer.setMessageBody(supportBody, isHTML: false)
    
    if MFMailComposeViewController.canSendMail() {
      self.present(mailComposer, animated: true, completion: nil)
    } else {
      return
    }
  }
  
  
  func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
    self.dismiss(animated: true, completion: nil)
  }
}
