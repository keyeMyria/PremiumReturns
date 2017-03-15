//
//  EditBrokerTableViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/10/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka
import ChameleonFramework

class EditBrokerTableViewController: FormViewController {
    
    static let headerHeight: Float = 30.0
    static let fontName = "Avenir-Medium"
    static let fontSize: CGFloat = 12.0
    
    var brokerFormController: BrokerFormController?
    var broker: Broker?
    var delegate: EditItemTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.backgroundColor = UIColor.white
        setUpNavigationButtons()

        if broker == nil {
            self.broker = Broker()
        }
        
        brokerFormController = BrokerFormController(form: form, controller: self, broker: broker!)
        brokerFormController?.formSetup()
        animateScroll = true
        rowKeyboardSpacing = 20
        
        updateInputFields(name: broker!.name, commission: broker!.commission)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func setUpNavigationButtons() {
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditBrokerTableViewController.cancelButtonPressed))
        cancelBarButton.tintColor = UIColor(hexString: Constants.barButtonTintColor)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EditBrokerTableViewController.doneButtonPressed))
        doneBarButton.tintColor = UIColor(hexString: Constants.barButtonTintColor)
        let topViewController = self.navigationController!.topViewController
        topViewController!.navigationItem.leftBarButtonItem = cancelBarButton
        topViewController!.navigationItem.rightBarButtonItem = doneBarButton
    }
    
    func updateInputFields(name: String, commission: Double) {
        let nameRow: TextRow? = form.rowBy(tag: BrokerFormFieldNames.Name.rawValue)
        nameRow?.value = name
        nameRow?.updateCell()
        
        let commissionRow: DecimalRow? = form.rowBy(tag: BrokerFormFieldNames.Commission.rawValue)
        commissionRow?.value = commission
        commissionRow?.updateCell()
    }

    func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonPressed() {
        let missingNameTitle = "Broker Name"
        let missingNameMessage = "Your broker needs a unique name."
        let validationErrors = form.validate()
        if validationErrors.count == 0 && BrokerController.sharedInstance.isUnique(brokerId: broker!.brokerId, name: broker!.name) {
            BrokerController.sharedInstance.save(broker: broker!)
            self.delegate?.doneButtonPressed()
            self.dismiss(animated: true, completion: nil)
        }
        print("\(validationErrors)")
        Utilities.sharedInstance.displayAlert(controller: self, title: missingNameTitle, message: missingNameMessage)
    }
}
