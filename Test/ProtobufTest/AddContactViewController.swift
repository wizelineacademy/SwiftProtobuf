//
//  AddContactViewController.swift
//  ProtobufTest
//
//  Created by Jorge R Ovalle Z on 8/4/17.
//  Copyright © 2017 Jorge R Ovalle Z. All rights reserved.
//

import UIKit

class AddContactViewController: UITableViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var address1stLine: UITextField!
    @IBOutlet weak var postCode: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var phoneType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveContact(_ sender: Any) {
        var contact = Contact()
        contact.firstName = firstName.text ?? ""
        contact.lastName = lastName.text ?? ""
        
        if let addressStr = address1stLine.text {
            var address = Address()
            address.addressLines = [addressStr]
            address.postcode = postCode.text ?? ""
            contact.address = address
        }
        
        if let phoneStr = phoneNumber.text {
            var phone = Phone()
            phone.number = phoneStr
            phone.type = phoneType.selectedSegmentIndex == 0 ? .landline : .mobile
            contact.phoneNumbers = [phone]
        }
        
        let _ = NetworkService().postContact(contact: contact, completion: { (result) in
            switch result {
            case .success(_):
                print("Success")
            case .error(let error):
                print("Error: \(error)")
            }
        })
            
    }
}
