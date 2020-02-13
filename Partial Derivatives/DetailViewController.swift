//
//  DetailViewController.swift
//  Partial Derivatives
//
//  Created by Jody Kocis on 3/4/19.
//  Copyright © 2019 Joseph Kocis. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var equationLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var isEquation = false;
    var equations: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        equationLabel.text = equations.first != nil ? equations.first : "No Equations"
        
        if (equationLabel.text == "No Equations") {
            textView.text = ""
            return
        }
        
        let equation = equationLabel.text != nil ? equationLabel.text! : ""
        let partialDerivatives = generatePartialDerivatives(equation: equation)
        outputPartialDerivatives(x: partialDerivatives.x, y: partialDerivatives.y)
        
    }
    
    // MARK: - Equations
    
    func inputData(isEquation: Bool, equations: [String]) {
        self.isEquation = isEquation
        self.equations = equations
    }
    
    func evaluatePartialDerivative(realWRT: String, exponentWRT: String, isPositive: Bool, exponent: Int, base: Int, other: String) -> String {
        
        print("realWRT: \(realWRT), exponentWRT: \(exponentWRT), isPositive: \(isPositive), exponent: \(exponent), base: \(base), other: \(other)")
        
        var output = ""
        
        if exponentWRT == "A" {
            return "+0"
        }
        if realWRT != exponentWRT {
            if (other == "A") {
                return "+0"
            }
            output += isPositive ? "+" : "-"
            if base != 1 {
                output += "\(base)"
            }
            output += exponentWRT
            output += "^\(exponent)"
            return output
        }
        
        
        //base times exponent, add other, add exponenetWRT, add ^exponenet - 1
        output += isPositive ? "+" : "-"
        if base * exponent == 0 {
            return "+0"
        }
        output += "\(base * exponent)"
        if other != "A" {
            output += "\(other)"
        }
        if exponent == 0 {
            return "+0"
        }
        if exponent == 1 {
            return output
        }
        output += exponentWRT
        output += "^\(exponent - 1)"
        
        return output
    }
    
    func generatePartialDerivatives(equation: String) -> (x: String, y: String) {
        
        var x = ""
        var y = ""
        
        var isFirst = true
        var inExponentMode = false
        var previousIsVariable = false
        var unchangedExponent = true
        
        var isPositive = true
        var exponent = 1
        var base = 0
        var other: String = "A"
        var wrt: String = "A"
        
        // x
        for character in equation {
            
            // Determine if positive or negative
            if isFirst {
                isFirst = false
                if character == "-" {
                    isPositive = false
                    continue
                }
                if character == "+" {
                    continue
                }
            }
            
            // Determine wrt
            if character == "x" || character == "X" || character == "y" || character == "Y" {
                if wrt != "A" {
                   other = wrt
                }
                wrt = "\(character)"
                previousIsVariable = true
                continue
            }
            
            if character == "^" {
                inExponentMode = true
                continue
            }
            
            // Determine exponent and base
            if inExponentMode {
                if let value = Int("\(character)") {
                    if exponent == 1 && unchangedExponent {
                        exponent = 0
                        unchangedExponent = false
                    }
                    if !unchangedExponent {
                        exponent *= 10
                    }
                    exponent += value
                    continue
                }
            } else {
                if let value = Int("\(character)") {
                    if !isFirst && !previousIsVariable {
                        base *= 10
                    }
                    base += value
                    continue
                }
            }
            
            // The next character
            if !isFirst && (character == "+" || character == "-") {
                if base == 0 {
                    base = 1
                }
                x += evaluatePartialDerivative(realWRT: "x", exponentWRT: wrt, isPositive: isPositive, exponent: exponent, base: base, other: other)
                
                isFirst = true
                inExponentMode = false
                previousIsVariable = false
                unchangedExponent = true
                
                isPositive = true
                exponent = 1
                base = 0
                other = "A"
                wrt = "A"
            }
            
        }
        if base == 0 {
            base = 1
        }
        x += evaluatePartialDerivative(realWRT: "x", exponentWRT: wrt, isPositive: isPositive, exponent: exponent, base: base, other: other)
        
        isFirst = true
        inExponentMode = false
        unchangedExponent = true
        
        isPositive = true
        exponent = 1
        base = 0
        other = "A"
        wrt = "A"
        
        
        
        // Y
        for character in equation {
            
            // Determine if positive or negative
            if isFirst {
                isFirst = false
                if character == "-" {
                    isPositive = false
                    continue
                }
                if character == "+" {
                    continue
                }
            }
            
            // Determine wrt
            if character == "x" || character == "X" || character == "y" || character == "Y" {
                if wrt != "A" {
                    other = wrt
                }
                wrt = "\(character)"
                previousIsVariable = true
                continue
            }
            
            if character == "^" {
                inExponentMode = true
                continue
            }
            
            // Determine exponent and base
            if inExponentMode {
                if let value = Int("\(character)") {
                    if exponent == 1 && unchangedExponent {
                        exponent = 0
                        unchangedExponent = false
                    }
                    if !unchangedExponent {
                        exponent *= 10
                    }
                    exponent += value
                    continue
                }
            } else {
                if let value = Int("\(character)") {
                    if !isFirst && !previousIsVariable {
                        base *= 10
                    }
                    base += value
                    continue
                }
            }
            
            // The next character
            if !isFirst && (character == "+" || character == "-") {
                if base == 0 {
                    base = 1
                }
                y += evaluatePartialDerivative(realWRT: "y", exponentWRT: wrt, isPositive: isPositive, exponent: exponent, base: base, other: other)
                
                isFirst = true
                inExponentMode = false
                previousIsVariable = false
                unchangedExponent = true
                
                isPositive = true
                exponent = 1
                base = 0
                other = "A"
                wrt = "A"
            }
            
        }
        if base == 0 {
            base = 1
        }
        y += evaluatePartialDerivative(realWRT: "y", exponentWRT: wrt, isPositive: isPositive, exponent: exponent, base: base, other: other)
        
        return (x, y)
    }
    
    func outputPartialDerivatives(x: String, y: String) {
        var output = ""
        var newX = x
        var newY = y
        
        if newX.first == "+" {
            newX.remove(at: newX.startIndex)
        }
        if newY.first == "+" {
            newY.remove(at: newY.startIndex)
        }
        output.append("fx(x,y) = \(newX)\n\nfy(x,y) = \(newY)")
        textView.text = output
    }
    
    
}
