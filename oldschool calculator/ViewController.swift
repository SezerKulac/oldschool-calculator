//
//  ViewController.swift
//  oldschool calculator
//
//  Created by Sezer Kulac on 26/01/16.
//  Copyright © 2016 Sezer Kulac. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Equals = "="
        case Empty = "Empty"
    }

    @IBOutlet weak var outputLabel: UILabel!
    
    var btnSound: AVAudioPlayer!
    var operands = [Double]()
    var currentOperation: Operation = Operation.Equals
    var userInTheMiddleOfEnteringNumber = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundUrl)
            btnSound.prepareToPlay()
        } catch let err as NSError {
           print(err.debugDescription)
        }
    }

    @IBAction func numberPressed(btn: UIButton!){
        btnSound.play()
        
        if !userInTheMiddleOfEnteringNumber  {
            // first number can't be 0
            if btn.tag != 0 {
                outputLabel.text = "\(btn.tag)"
                userInTheMiddleOfEnteringNumber = true
            }
            
            // if current operation is equal then clear the operands
            if currentOperation == Operation.Equals {
                operands.removeAll()
            }
        } else {
            outputLabel.text = outputLabel.text! + "\(btn.tag)"
        }
    }

    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }

    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(Operation.Equals)
    }
    
    func processOperation(op: Operation) {
        playSound()
        
        // only addpend the display once
        // this guards against cases where user keeps hitting operations
        if userInTheMiddleOfEnteringNumber {
            operands.append(Double(outputLabel.text!)!)
        }
        
        // if at least two operators then do some math
        if operands.count > 1 {
            let leftOperand = operands.first!
            operands.removeFirst()
            
            let rightOperand = operands.first!
            operands.removeFirst()
            
            var answer = 0.0
            if currentOperation == Operation.Multiply {
                answer = leftOperand * rightOperand
            } else if currentOperation == Operation.Divide {
                answer = leftOperand / rightOperand
            } else if currentOperation == Operation.Add {
                answer = leftOperand + rightOperand
            } else if currentOperation == Operation.Subtract {
                answer = leftOperand - rightOperand
            }
            
            // add the answer back to the front of the array
            operands.insert(answer, atIndex: 0)
            outputLabel.text = "\(answer)"
        }
        
        currentOperation = op
        userInTheMiddleOfEnteringNumber = false
    }
    
    func playSound() {
        if btnSound.playing {
            btnSound.stop()
        }
        
        btnSound.play()
    }
}

