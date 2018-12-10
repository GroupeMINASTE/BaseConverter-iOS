//
//  TableViewController.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 10/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    typealias Base = (name: String, value: Int)

    var bases = [Base]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bases += [Base(name: "Decimal", value: 10), Base(name: "Binary", value: 2), Base(name: "Hexadecimal", value: 16)]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "baseCell", for: indexPath) as! TableViewCell

        let base = bases[indexPath.row]
        
        cell.tableViewController = self
        cell.name.text = base.name
        cell.power = base.value

        return cell
    }
    
    func apply(number: Int) {
        for i in 0..<bases.count {
            var result = ""
            var left = number
            var nums = [String]()
            
            if bases[i].value >= 2 {
                nums += ["0", "1"]
            }
            if bases[i].value >= 10 {
                nums += ["2", "3", "4", "5", "6", "7", "8", "9"]
            }
            if bases[i].value >= 16 {
                nums += ["A", "B", "C", "D", "E", "F"]
            }
            
            var maxpow = 0
            while pow(Decimal(bases[i].value), maxpow+1)-1 < Decimal(left) {
                maxpow += 1
            }
            
            for j in 0...maxpow {
                let current = NSDecimalNumber(decimal: pow(Decimal(bases[i].value), maxpow-j)).intValue
                let hmt = left / current
                result += nums[hmt]
                left -= hmt * current
            }
            
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! TableViewCell
            cell.value.text = result
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
