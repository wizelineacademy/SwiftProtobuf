//
//  DetailContactViewController.swift
//  ProtobufTest
//
//  Created by Jorge R Ovalle Z on 8/4/17.
//  Copyright © 2017 Jorge R Ovalle Z. All rights reserved.
//

import UIKit

class DetailContactViewController: UITableViewController {

    var contact: Contact?
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPostCode: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var phoneType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let contact = contact else { return }
        
        lblName.text = contact.firstName + " " + contact.lastName
        
        if !contact.address.addressLines.isEmpty {
            lblAddress.text = contact.address.addressLines[0]
            lblPostCode.text = contact.address.postcode
        }
        
        if let phoneNumber = contact.phoneNumbers.first {
            lblPhone.text = phoneNumber.number
            
            switch phoneNumber.type {
            case .mobile:
                self.phoneType.selectedSegmentIndex = 1
            case .landline:
                self.phoneType.selectedSegmentIndex = 0
            case .sip:
                self.phoneType.selectedSegmentIndex = 0
            default: return
            }
        } else {
            self.phoneType.alpha = 0
        }
    }
}
