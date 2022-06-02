//
//  TableViewController.swift
//  ConsultaArchivos
//
//  Created by Oscar Hernandez on 01/06/22.
//

import UIKit

class TableViewController: UITableViewController {
    
    var menu = ["Excel", "PDF", "Image"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menu.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menu[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "details", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
            case "details":
            let detailsVC = segue.destination as! ViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                detailsVC.options = menu[indexPath.row]
            }

            default:
                print("hi bro!")
        }
    }

}
