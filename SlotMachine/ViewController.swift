//
//  ViewController.swift
//  SlotMachine
//
//  Created by delmarz on 1/6/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //Containers
    
    var firstContainer: UIView!
    var secondContainer: UIView!
    var thirdContainer: UIView!
    var fourthContainer: UIView!
    
    
    //Information Label
    
    var creditLabel: UILabel!
    var betLabel: UILabel!
    var winnerLabel: UILabel!
    
    var creditTitleLabel: UILabel!
    var betTitleLabel: UILabel!
    var winnerTitleLabel: UILabel!
    
    //Fourth Container Button
    
    var resetButton: UIButton!
    var betOneButton: UIButton!
    var betMaxButton: UIButton!
    var spinButton: UIButton!
    
    
    //Top Container
    
    var titleLabel: UILabel!
    
    //Constants
    
    let kNumberForContainer = 3
    let kNumberForSlot = 3
    
    let kThird:CGFloat = 1.0/3.0
    let kSixth:CGFloat = 1.0/6.0
    let kEighth:CGFloat = 1.0/8.0
    let kHalf:CGFloat = 1.0/2.0
    
    let kMarginForSlot:CGFloat = 2
    let kMarginForView:CGFloat = 10
    
    //Slots Array
    
    var slots:[[Slot]] = []
    
    var credits:Int = 0
    var currentBet:Int = 0
    var winning:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        setupContainers()
        setupFirstContainer(self.firstContainer)
        setupSecondContainer(self.secondContainer)
        setupThirdContainer(self.thirdContainer)
        setupFourthContainer(self.fourthContainer)
        
        hardReset()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //IBActions
    
    func resetButtonPressed(button: UIButton) {
        
        println("reset button")
        hardReset()
        
    }
    
    func betOneButtonPressed(button: UIButton) {
       
        
        if self.credits <= 0 {
            showAlertWithText(header: "No More Credits", message: "Reset Game")
        } else{
            
            if self.currentBet < 5 {
                self.currentBet += 1
                self.credits -= 1
                self.winning = 0
                updateMainView()
            }else {
                showAlertWithText(message: "You can only bet 5 credits at a time")
            }
        }
        
        
    }
    
    func betMaxButtonPressed(button: UIButton) {
    
        
        if self.credits <= 5 {
            showAlertWithText(header: "Not Enough Credit", message: "Bet Less")
        } else {
            if self.currentBet < 5 {
                self.credits -= 5 - self.currentBet
                self.currentBet = 5
                self.winning = 0
                
                updateMainView()
            }else {
                showAlertWithText(message: "You can only bet 5 credits at a time")
            }
        }
        
    }
    
    func spinButtonPressed(button: UIButton) {
     
        if self.currentBet == 0 {
            
            var alert = UIAlertController(title: "Warning", message: "Place a Bet before spinning", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        } else {
            self.removeSlotImageViews()
            self.slots = Factory.createSlots()
            self.setupSecondContainer(self.secondContainer)
            
            var winningMultiplier = SlotBrain.computeWinnings(self.slots)
            self.winning = winningMultiplier * self.currentBet
            self.credits += winning
            self.currentBet = 0
            
            updateMainView()
        }
        
   
        
    }
    
    
    func setupContainers() {
        
        self.firstContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, self.view.bounds.origin.y, self.view.bounds.width - (kMarginForView * 2), self.view.bounds.height * kSixth))
        self.firstContainer.backgroundColor = UIColor.redColor()
        self.view.addSubview(firstContainer)
        
        self.secondContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, self.view.bounds.origin.y + firstContainer.frame.height, self.view.bounds.width - (kMarginForView * 2), self.view.bounds.height * (3 * kSixth)))
        self.secondContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(secondContainer)
        
        self.thirdContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, self.view.bounds.origin.y + firstContainer.frame.height + secondContainer.frame.height, self.view.bounds.width - (kMarginForView * 2), self.view.bounds.height * kSixth))
        self.thirdContainer.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(thirdContainer)
        
        self.fourthContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, self.view.bounds.origin.y + firstContainer.frame.height + secondContainer.frame.height + thirdContainer.frame.height, self.view.bounds.width - (kMarginForView * 2), self.view.bounds.height * kSixth))
        self.fourthContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(fourthContainer)
    }
    
    
    func setupFirstContainer(containerView: UIView) {
        
        self.titleLabel = UILabel()
        self.titleLabel.text = "Super SLots"
        self.titleLabel.textColor = UIColor.yellowColor()
        self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        self.titleLabel.sizeToFit()
        self.titleLabel.center = containerView.center
        containerView.addSubview(self.titleLabel)
        
    }
    
    func setupSecondContainer(containerView: UIView) {
        
        for var containerNumber = 0; containerNumber < kNumberForContainer; containerNumber++ {
            for var slotNumber = 0; slotNumber < kNumberForSlot; slotNumber++ {
                
                var slot:Slot
                var slotImageView = UIImageView()
                
                if self.slots.count != 0 {
                    let slotContainer = self.slots[containerNumber]
                    slot = slotContainer[slotNumber]
                    slotImageView.image = slot.image
                } else {
                    slotImageView.image = UIImage(named: "Ace")
                }
                
                slotImageView.frame = CGRectMake(containerView.bounds.origin.x + (containerView.bounds.width * CGFloat(containerNumber) * kThird), containerView.bounds.origin.y + (containerView.bounds.height * CGFloat(slotNumber) * kThird), containerView.bounds.width * kThird - kMarginForSlot, containerView.bounds.height * kThird - kMarginForSlot)
                containerView.addSubview(slotImageView)
            }
        }
        
    }
    
    
    func setupThirdContainer(containerView: UIView) {
        
        self.creditLabel = UILabel()
        self.creditLabel.text = "000000"
        self.creditLabel.textColor = UIColor.redColor()
        self.creditLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.creditLabel.sizeToFit()
        self.creditLabel.center = CGPointMake(containerView.frame.width * kSixth, containerView.frame.height * kThird)
        self.creditLabel.textAlignment = NSTextAlignment.Center
        self.creditLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.creditLabel)
        
        self.betLabel = UILabel()
        self.betLabel.text = "0000"
        self.betLabel.textColor = UIColor.redColor()
        self.betLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.betLabel.sizeToFit()
        self.betLabel.center = CGPointMake(containerView.frame.width * kSixth * 3, containerView.frame.height * kThird)
        self.betLabel.textAlignment = NSTextAlignment.Center
        self.betLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.betLabel)
        
        self.winnerLabel = UILabel()
        self.winnerLabel.text = "000000"
        self.winnerLabel.textColor = UIColor.redColor()
        self.winnerLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.winnerLabel.sizeToFit()
        self.winnerLabel.center = CGPointMake(containerView.frame.width * kSixth * 5, containerView.frame.height * kThird)
        self.winnerLabel.textAlignment = NSTextAlignment.Center
        self.winnerLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.winnerLabel)
        
        self.creditTitleLabel = UILabel()
        self.creditTitleLabel.text = "Credits"
        self.creditTitleLabel.textColor = UIColor.blackColor()
        self.creditTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.creditTitleLabel.sizeToFit()
        self.creditTitleLabel.center = CGPointMake(containerView.frame.width * kSixth, containerView.frame.height * kThird * 2)
        containerView.addSubview(self.creditTitleLabel)
        
        self.betTitleLabel = UILabel()
        self.betTitleLabel.text = "Bet"
        self.betTitleLabel.textColor = UIColor.blackColor()
        self.betTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.betTitleLabel.sizeToFit()
        self.betTitleLabel.center = CGPointMake(containerView.frame.width * kSixth * 3, containerView.frame.height * kThird * 2)
        containerView.addSubview(self.betTitleLabel)
        
        self.winnerTitleLabel = UILabel()
        self.winnerTitleLabel.text = "Winner Paid"
        self.winnerTitleLabel.textColor = UIColor.blackColor()
        self.winnerTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.winnerTitleLabel.sizeToFit()
        self.winnerTitleLabel.center = CGPointMake(containerView.frame.width * kSixth * 5, containerView.frame.height * kThird * 2)
        containerView.addSubview(self.winnerTitleLabel)
        
    }
    
    func setupFourthContainer(containerView: UIView) {
        
        self.resetButton = UIButton()
        self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
        self.resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.resetButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.resetButton.sizeToFit()
        self.resetButton.center = CGPointMake(containerView.frame.width * kEighth, containerView.frame.height * kHalf)
        self.resetButton.backgroundColor = UIColor.lightGrayColor()
        self.resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.resetButton)
        
        self.betOneButton = UIButton()
        self.betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
        self.betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betOneButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betOneButton.sizeToFit()
        self.betOneButton.center = CGPointMake(containerView.frame.width * kEighth * 3, containerView.frame.height * kHalf)
        self.betOneButton.backgroundColor = UIColor.greenColor()
        self.betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.betOneButton)
        
        self.betMaxButton = UIButton()
        self.betMaxButton.setTitle("Bet Max", forState: UIControlState.Normal)
        self.betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betMaxButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betMaxButton.sizeToFit()
        self.betMaxButton.center = CGPointMake(containerView.frame.width * kEighth * 5, containerView.frame.height * kHalf)
        self.betMaxButton.backgroundColor = UIColor.redColor()
        self.betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.betMaxButton)
        
        self.spinButton = UIButton()
        self.spinButton.setTitle("Spin", forState: UIControlState.Normal)
        self.spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.spinButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.spinButton.sizeToFit()
        self.spinButton.center = CGPointMake(containerView.frame.width * kEighth * 7, containerView.frame.height * kHalf)
        self.spinButton.backgroundColor = UIColor.greenColor()
        self.spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.spinButton)
        
        
    }
    
    // Helpers
    
    
    func removeSlotImageViews() {
        
        if self.secondContainer != nil {
            let container:UIView? = self.secondContainer!
            let subViews:Array? = container!.subviews
            for view in subViews! {
                view.removeFromSuperview()
            }
        }
    }
    
    func hardReset() {
        removeSlotImageViews()
        self.slots.removeAll(keepCapacity: true)
        self.setupSecondContainer(self.secondContainer)
        self.credits = 50
        self.currentBet = 0
        self.winning = 0
        updateMainView()
    }
    
    
    func updateMainView() {
        
        self.creditLabel.text = "\(self.credits)"
        self.winnerLabel.text = "\(self.winning)"
        self.betLabel.text = "\(self.currentBet)"
    }
    
    func showAlertWithText(header:String = "Warning", message: String) {
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}

