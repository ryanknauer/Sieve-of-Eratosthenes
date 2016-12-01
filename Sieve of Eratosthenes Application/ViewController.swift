//
//  ViewController.swift
//  Sieve of Eratosthenes Application
//
//  Created by Ryan Knauer on 11/23/16.
//  Copyright © 2016 RyanKnauer. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    var collectionViewSize : Int!
    var numbersCollection : UICollectionView!
    var nonPrimeNumbers : [Int] = []
    var primeNumbers : [Int] = []
    var primeArray : [Bool] = []
    var textField : UITextField!
    var textFieldWidth : CGFloat!
    var textFieldHeight : CGFloat!
    var instructionsLabel : UILabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        collectionViewSize = 0
        setupCollectionView()
        

        
        setupInstructionsLabel()
        view.addSubview(instructionsLabel)
        
        setupTextField()
        view.addSubview(textField)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewSize - 1
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("numberCell", forIndexPath: indexPath) as! NumberCell
        
        cell.label.text = String(indexPath.item + 2)
        
        
        if nonPrimeNumbers.contains(indexPath.item + 2){
            cell.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        } else{
            cell.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        }
        
        return cell
        
    }
    
    
    
    func runSievesAlgo(){
        var sqrtN = sqrt(Double(collectionViewSize))
        
        if sqrtN % 1 == 0{
            sqrtN -= 1
        } else {
            sqrtN = round(sqrtN)
        }
        
        for i in 2...Int(sqrtN){
            if !nonPrimeNumbers.contains(i - 2){
                let iSquared = Int(pow(Double(i), 2.0))
                var j = iSquared
                var k = 0
                while j < collectionViewSize{
                    let a = j
                    let sleepTime = 500000 / collectionViewSize
                    usleep(UInt32(sleepTime))
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.removeItemAtIndex(a)
                    })
                    k++
                    j =  iSquared + (k*i)
                    
                }
                
            }
        }
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(slideIOAnimationDuration * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.showLabeles()
        }
    }
    

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        nonPrimeNumbers = []
        
        let numString = textField.text
        if let num : Int = Int(numString!) {
            hideLabels()
            collectionViewSize = num
            numbersCollection.reloadData()
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, {
                self.runSievesAlgo()
            })
        } else {
            print("invalid input")
        }
        
        return true
    }
    
    
    func removeItemAtIndex(i : Int){
        nonPrimeNumbers.append(i)
        let indexPath = NSIndexPath(forItem: i - 2, inSection: 0)
        numbersCollection.reloadItemsAtIndexPaths([indexPath])
        
    }
    
    
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.itemSize = CGSize(width: 50, height: 50)
        
        let frame = view.frame
        numbersCollection = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        numbersCollection.delegate = self
        numbersCollection.dataSource = self
        numbersCollection.registerClass(NumberCell.self, forCellWithReuseIdentifier: "numberCell")
        numbersCollection.backgroundColor = UIColor.whiteColor()
        view.addSubview(numbersCollection)
    }
    
    
    func slideInAllCells(){
        CATransaction.begin()
        for i in 0..<collectionViewSize{
            let index = NSIndexPath(forItem: i, inSection: 0)
            if let cell = numbersCollection.cellForItemAtIndexPath(index){
                if  (i % 2 == 0){
                    self.slideInAnimation(cell, inFrom: .top, slideOut: false)
                }else{
                    self.slideInAnimation(cell, inFrom: .bottom, slideOut: false)
                }
                
            }
            
        }
        numbersCollection.hidden = false
        CATransaction.commit()
    }
    
    
    func setupTextField(){
        textFieldWidth = view.frame.width
        textFieldHeight = 50
        let textFieldFrame = CGRect(x: 0, y: instructionsLabel.frame.origin.y + instructionsLabel.frame.height, width: textFieldWidth, height: textFieldHeight)
        textField = UITextField(frame: textFieldFrame)
        textField.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.65)
        textField.placeholder = "Insert Number to Find All Primes Smaller It"
        textField.returnKeyType = .Done
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.autocorrectionType = UITextAutocorrectionType.No
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.textAlignment = .Center
        textField.delegate = self
    }
    
    
    func hideLabels(){
        slideInAnimation(textField, inFrom: .bottom, slideOut: true)
        slideInAnimation(instructionsLabel, inFrom: .top, slideOut: true)
    }
    
    
    func showLabeles(){
        textField.text = ""
        slideInAnimation(textField, inFrom: .bottom, slideOut: false)
        slideInAnimation(instructionsLabel, inFrom: .top, slideOut: false)
    }
    
    
    func setupInstructionsLabel(){
        instructionsLabel.frame.size = CGSize(width: view.frame.width, height: view.frame.height / 6)
        instructionsLabel.center = view.center
        instructionsLabel.text = "Please Insert A Number:"
        instructionsLabel.textAlignment = .Center
        instructionsLabel.numberOfLines = 0
        instructionsLabel.font = UIFont(name: "Helvetica", size: 25)
        instructionsLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.65)
    }

}


