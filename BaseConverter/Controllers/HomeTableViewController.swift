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
        BaseSection(name: "Convert a number", bases: [
            Base(id: 1, name: "DEC", value: 10, cell: "baseCell"),
            Base(id: 2, name: "BIN", value: 2, cell: "baseCell"),
            Base(id: 3, name: "OCT", value: 8, cell: "baseCell"),
            Base(id: 4, name: "HEX", value: 16, cell: "baseCell")
        ]),
        BaseSection(name: "Convert a color", bases: [
            Base(id: 5, name: "", value: 16, cell: "colorCell")
        ]),
        BaseSection(name: "Convert a text", bases: [
            Base(id: 6, name: "TXT", value: 16, cell: "textCell")
        ])
    ]
    
    var currents: [Int64] = [0]
    var source = Source(base: Base(id: 0, name: "", value: 0, cell: ""), string: "0")

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
        tableView.register(ColorTableViewCell.self, forCellReuseIdentifier: "colorCell")
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "labelCell")
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "textCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Select first cell
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BaseTableViewCell {
            cell.input.field.becomeFirstResponder()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return bases.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == bases.count ? 2 : bases[section].bases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == bases.count ? "More" : bases[section].name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // More cells
        if indexPath.section == bases.count {
            return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: indexPath.row == 0 ? "Groupe MINASTE" : "Donate", accessory: .disclosureIndicator)
        }
        
        // Classic cells
        let base = bases[indexPath.section].bases[indexPath.row]
        return (tableView.dequeueReusableCell(withIdentifier: base.cell, for: indexPath) as! BaseCell).with(base: base, values: currents, source: self.source, delegate: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // More cells
        if indexPath.section == bases.count {
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
        // Convert values
        let values = value.components(separatedBy: .whitespacesAndNewlines)
            .map({ Int64($0, radix: base.value) })
            .filter({ $0 != nil })
            .map({ $0! })
        
        // Call with values
        inputChanged(values, for: base, source: value)
    }
    
    func inputChanged(_ values: [Int64], for base: Base, source: String) {
        // Update value
        self.currents = values
        
        // Update source
        self.source = Source(base: base, string: source.trimmingCharacters(in: .whitespacesAndNewlines))
        
        // Get cells
        let cells = (0 ..< bases.count).map({ section in
            (0 ..< bases[section].bases.count).map({ row in
                tableView.cellForRow(at: IndexPath(row: row, section: section))
            })
        }).reduce([], +)
        
        // Update tableView
        for cell in cells {
            // Check cell type and get base
            if let cell = cell as? BaseCell, let cbase = cell.base, base.id != cbase.id {
                // Update text
                cell.with(base: cbase, values: self.currents, source: self.source, delegate: self)
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
