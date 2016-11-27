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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let tfWidth : CGFloat = self.view.frame.width * (0.9)
        let textFieldFrame = CGRect(x: (self.view.frame.width / 2) - (tfWidth / 2), y: self.view.frame.height / 2, width: tfWidth, height: 50)
        textField = UITextField(frame: textFieldFrame)
        textField.placeholder = "Insert Number to Find All Primes Smaller It"
        textField.returnKeyType = .Done
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.autocorrectionType = UITextAutocorrectionType.No
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.delegate = self
        

        
        collectionViewSize = 100
        setupCollectionView()
        
        view.addSubview(textField)
        
    }
    
    override func viewDidAppear(animated: Bool) {

//        view.addSubview(numbersCollection)
//        runSievesAlgo()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewSize - 1
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("numberCell", forIndexPath: indexPath) as! numberCell
        
        cell.label.text = String(indexPath.item + 2)
        
        
        if nonPrimeNumbers.contains(indexPath.item + 2){
            cell.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        } else{
            cell.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        }
        

        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    

    
    func runSievesAlgo(){
        var sqrtN = sqrt(Double(collectionViewSize))
        if sqrtN % 1 == 0{
            sqrtN -= 1
        } else {
            sqrtN = round(sqrtN)
        }
        
        var delayTime : UInt64 = 1
        let delayTimeChange : UInt64 = 1
        
        for i in 2...Int(sqrtN){
            let indexPath = NSIndexPath(forItem: i - 2, inSection: 0)
            let cell = numbersCollection.cellForItemAtIndexPath(indexPath) as! numberCell
            if cell.prime{
                var iSquared = Int(pow(Double(i), 2.0))
                var j = iSquared
                var k = 0
                
                while j < collectionViewSize{
                    
                    let a = j
                    delayTime += delayTimeChange
                    let time = Int64(delayTime * NSEC_PER_SEC)
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, time)
                    print(time)
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {self.removeItemAtIndex(a)})
                    k++
                    j =  iSquared + (k*i)
                    
                }
                
            }
        }
    }
    

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        do {
            let numString = textField.text
            if let num : Int = try Int(numString!) {
                //collectionViewSize = num
                
                runSievesAlgo()
                return true
            }
        }catch {
            print("Please insert an int")
            
        }
        return true
    }
    
    
    
    func removeItemAtIndex(i : Int){
        print("here\(i)")
        nonPrimeNumbers.append(i)
        let indexPath = NSIndexPath(forItem: i - 2, inSection: 0)
        let cell = numbersCollection.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        numbersCollection.reloadItemsAtIndexPaths([indexPath])
    }
    
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.itemSize = CGSize(width: 50, height: 50)
        
        
        numbersCollection = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        numbersCollection.delegate = self
        numbersCollection.dataSource = self
        numbersCollection.registerClass(numberCell.self, forCellWithReuseIdentifier: "numberCell")
        numbersCollection.backgroundColor = UIColor.whiteColor()
        view.addSubview(numbersCollection)
    }



}


