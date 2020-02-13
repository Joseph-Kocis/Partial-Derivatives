//
//  ViewController.swift
//  Partial Derivatives
//
//  Created by Jody Kocis on 3/3/19.
//  Copyright © 2019 Joseph Kocis. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    let defaults = UserDefaults.standard
    var numEquations = 0
    
    var currentEquation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        numEquations = getEquations().count
    }
    
    
    
    // MARK: - Equations
    
    func getEquations() ->[String] {
        return defaults.object(forKey: equationsKey) as? [String] ?? [String]()
    }
    
    // Adding an equation
    func addEquation(equation: String) {
        var equations = defaults.object(forKey: equationsKey) as? [String] ?? [String]()
        equations.append(equation)
        defaults.set(equations, forKey: equationsKey)
        numEquations = getEquations().count
        tableView.reloadData()
    }
    
    // Removing an equation
    func removeEquation(index: Int) {
        var equations = defaults.object(forKey: equationsKey) as? [String] ?? [String]()
        equations.remove(at: index)
        defaults.set(equations, forKey: equationsKey)
        numEquations = getEquations().count
        tableView.reloadData()
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        presentPopoverVC(sender)
    }
    
    @IBAction func editButton(_ sender: Any) {
        if tableView.isEditing == true {
            tableView.isEditing = false
            editButton.title = "Edit"
        } else {
            tableView.isEditing = true
            editButton.title = "Done"
        }
    }
    
    // MARK: - Popover Presentation Controller
    
    func presentPopoverVC(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popoverVC = storyboard.instantiateViewController(withIdentifier: "PopoverViewController")
        popoverVC.modalPresentationStyle = UIModalPresentationStyle.popover
        if let barButtonItem = sender as? UIBarButtonItem, let popover = popoverVC.popoverPresentationController {
            popover.barButtonItem = barButtonItem
            popover.delegate = self
        }
        present(popoverVC, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.fullScreen
    }
    
    @objc func create(s : AnyObject) {
        if let navigationController = self.presentedViewController as? UINavigationController, let viewController = navigationController.viewControllers[0] as? PopoverViewController, let text = viewController.textField.text {
            
            if !viewController.checkEquationFormat(equation: text).0 {
                return
            }
            addEquation(equation: text)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel(s: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        
        navigationController.navigationBar.tintColor = #colorLiteral(red: 0.9882996678, green: 0.1471632719, blue: 0.04497649521, alpha: 1)
        
        let btnDone = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(create(s:)))
        navigationController.topViewController!.navigationItem.rightBarButtonItem = btnDone
        
        let btnCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(s:)))
        navigationController.topViewController!.navigationItem.leftBarButtonItem = btnCancel
        
        return navigationController
    }
    
    // MARK: - Table View
    
    // The number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numEquations
    }
    
    // Creates each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: equationsCellIdentifier, for: indexPath) as? MathTableViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: equationsCellIdentifier, for: indexPath)
        }
        
        cell.equationsLabel.text = "Equation"
        cell.equationsValueLabel.text = getEquations()[indexPath.row]
        return cell
    }
    
    
    // Deleting a Cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeEquation(index: indexPath.row)
        }
    }
    
    // MARK: - Seques
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == toDetailSegueIdentifier, let indexPath = tableView.indexPathForSelectedRow, let navigationVC = segue.destination as? UINavigationController, let detailVC = navigationVC.children[0] as? DetailViewController, let cell = tableView.cellForRow(at: indexPath) as? MathTableViewCell, let equationsValue = cell.equationsValueLabel.text {
            
            detailVC.inputData(isEquation: cell.equationsLabel.text == "Equation", equations: [equationsValue])
            detailVC.title = cell.equationsLabel.text
        }
        
    }
    
    
}

