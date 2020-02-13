//
//  PopoverViewController.swift
//  Partial Derivatives
//
//  Created by Jody Kocis on 3/3/19.
//  Copyright © 2019 Joseph Kocis. All rights reserved.
//

import Foundation
import UIKit

class PopoverViewController: UIViewController, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            
            if !checkEquationFormat(equation: text).0 {
                //handle incorrect equation
                return true
            } else {
                addEquation(equation: text)
            }
            
        }
        textField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        return true
    }
    
    // Adding an equation
    func addEquation(equation: String) {
        var equations = defaults.object(forKey: equationsKey) as? [String] ?? [String]()
        equations.append(equation)
        defaults.set(equations, forKey: equationsKey)
        
        if let viewController = presentingViewController?.children[0].children[0] as? MasterViewController {
            viewController.numEquations = viewController.getEquations().count
            viewController.tableView.reloadData()
        }
    }
    
    
    func checkEquationFormat(equation: String) -> (Bool, Character) {
        
        var inExponentMode = false
        
        // each term can only have one x and one y
        var previousTerm = ""
        
        
        // handle if exponent is first or last character
        if (equation.last == "^" || equation.first == "^" || isOperator(character: equation.last ?? "A")) {
            presentInvalivdInputAlert(character: "^")
            return (false, "^")
        }
        // handle if exponenet is not attached to x or y
        var previous = equation.first ?? " "
        
        
        // number or variable or operator
        for character in equation {
            
            // if exponent then check that only numbers until operator
            if (isOperator(character: character) || character == "^") {
                var hasX = false
                var hasY = false
                for term in previousTerm {
                    if (term == "x" || term == "X") {
                        if (hasX == true) {
                            presentInvalivdInputAlert(character: term)
                            return (false, term)
                        }
                        hasX = true
                    }
                    if (term == "y" || term == "Y") {
                        if (hasY == true) {
                            presentInvalivdInputAlert(character: term)
                            return (false, term)
                        }
                        hasY = true
                    }
                }
                previousTerm = ""
            }
            
            if isOperator(character: character) && isOperator(character: previous) {
                presentInvalivdInputAlert(character: character)
                return (false, character)
            }
            
            
            if inExponentMode && !isNumber(character: character) && !isOperator(character: character) {
                presentInvalivdInputAlert(character: character)
                return (false, character)
            }
            
            
            if inExponentMode && isOperator(character: character) {
                inExponentMode = false
            }
            if character == "^" {
                if (!isXORY(character: previous)) {
                    presentInvalivdInputAlert(character: character)
                    return (false, character)
                }
                inExponentMode = true
            }
            
            if !inExponentMode && !isXYOrNumber(character: character) && !isOperator(character: character) && character != "^" {
                presentInvalivdInputAlert(character: character)
                return (false, character)
            }
            
            
            previous = character
            previousTerm += "\(character)"
        }
        
        var hasX = false
        var hasY = false
        for term in previousTerm {
            if (term == "x" || term == "X") {
                if (hasX == true) {
                    presentInvalivdInputAlert(character: term)
                    return (false, term)
                }
                hasX = true
            }
            if (term == "y" || term == "Y") {
                if (hasY == true) {
                    presentInvalivdInputAlert(character: term)
                    return (false, term)
                }
                hasY = true
            }
        }
        
        return (true, "A")
    }
    
    func presentInvalivdInputAlert(character: Character) {
        let myAlert = UIAlertController(title: "Error", message: "Invalid character: \(character)", preferredStyle: UIAlertController.Style.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func isXORY(character: Character) -> Bool {
        switch character {
        case "x":
            return true
        case "X":
            return true
        case "y":
            return true
        case "Y":
            return true
        default:
            return false
        }
    }
    
    func isOperator(character: Character) -> Bool {
        switch character {
        case "+":
            return true
        case "-":
            return true
        default:
            return false
        }
    }
    
    func isNumber(character: Character) -> Bool {
        switch character {
        case "0":
            return true
        case "1":
            return true
        case "2":
            return true
        case "3":
            return true
        case "4":
            return true
        case "5":
            return true
        case "6":
            return true
        case "7":
            return true
        case "8":
            return true
        case "9":
            return true
        default:
            return false
        }
    }
    
    func isXYOrNumber(character: Character) -> Bool {
        switch character {
        case "x":
            return true
        case "X":
            return true
        case "y":
            return true
        case "Y":
            return true
        case "0":
            return true
        case "1":
            return true
        case "2":
            return true
        case "3":
            return true
        case "4":
            return true
        case "5":
            return true
        case "6":
            return true
        case "7":
            return true
        case "8":
            return true
        case "9":
            return true
        default:
            return false
        }
    }
    
}
