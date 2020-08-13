//
//  HomeTableViewController.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 10/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit
import DonateViewController

class HomeTableViewController: UITableViewController, InputChangedDelegate, DonateViewControllerDelegate {
    
    let bases = [
        Base(name: "DEC", value: 10),
        Base(name: "BIN", value: 2),
        Base(name: "OCT", value: 8),
        Base(name: "HEX", value: 16)
    ]
    var current: Int64? = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        navigationItem.title = "BaseConverter"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        // Make cells auto sizing
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        // Register cells
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: "baseCell")
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "labelCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Select first cell
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BaseTableViewCell {
            cell.field.becomeFirstResponder()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? bases.count : 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Convert" : "More"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // More cells
        if indexPath.section == 1 {
            return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: indexPath.row == 0 ? "Groupe MINASTE" : "Donate", accessory: .disclosureIndicator)
        }
        
        // Base cell
        return (tableView.dequeueReusableCell(withIdentifier: "baseCell", for: indexPath) as! BaseTableViewCell).with(base: bases[indexPath.row], value: current, delegate: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // More cells
        if indexPath.section == 1 {
            // Groupe MINASTE
            if indexPath.row == 0 {
                // Open URL
                if let url = URL(string: "https://www.groupe-minaste.org/") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            
            // Donate
            else if indexPath.row == 1 {
                // Create a controller
                let controller = DonateViewController()
                
                // Set delegate
                controller.delegate = self
                
                // Add donations
                controller.add(identifier: "me.nathanfallet.BaseConverter.donation1")
                controller.add(identifier: "me.nathanfallet.BaseConverter.donation2")
                controller.add(identifier: "me.nathanfallet.BaseConverter.donation3")
                
                // Set strings
                controller.title = "Donate"
                controller.header = "Select an amount to donate:"
                controller.footer = "This donation will help our organization to develop its projects, mainly Extopy, the social network we are working on, which will require some storage for its servers."
                
                // Show it
                navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func inputChanged(_ value: String, for base: Base) {
        // Update value
        self.current = Int64(value, radix: base.value)
        
        // Update tableView
        for id in 0 ..< bases.count {
            // Check cell type and get base
            if let cell = tableView.cellForRow(at: IndexPath(row: id, section: 0)) as? BaseTableViewCell, let cbase = cell.base, base.value != cbase.value {
                // Update text
                cell.with(base: cbase, value: self.current, delegate: self)
            }
        }
    }
    
    func donateViewController(_ controller: DonateViewController, didDonationSucceed donation: Donation) {
        let alert = UIAlertController(title: "Thanks for donating to our organization!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func donateViewController(_ controller: DonateViewController, didDonationFailed donation: Donation) {
        print("Donation failed.")
    }

}
