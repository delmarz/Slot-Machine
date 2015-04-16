//
//  SlotBrain.swift
//  SlotMachine
//
//  Created by delmarz on 1/9/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

import Foundation

class SlotBrain {
    
    
    class func computeWinnings(slots:[[Slot]]) -> Int {
        var slotInRows = unpackSlotsIntoRows(slots)
        
        var winnings = 0
        var flushWinCount = 0
        var threeOfKindWinCount = 0
        var straightWinCount = 0
        
        for slotRow in slotInRows {
            
            if checkFlush(slotRow) == true {
                println("Flush")
                winnings += 1
                flushWinCount = 1
            }
            
            if checkStraight(slotRow) == true {
                println("Straight in a Row")
                winnings += 1
                straightWinCount = 1
            }
            
            if checkThreeOfKind(slotRow) == true {
                println("Three of A kind")
                winnings += 3
                threeOfKindWinCount = 1
            }
            
        }
        
        if flushWinCount == 3 {
            println("Royal Flush")
            winnings += 15
        }
        
        if straightWinCount == 3 {
            println("Epic Straight")
            winnings += 1000
        }
        
        if threeOfKindWinCount == 3 {
            println("Threes all around")
            winnings += 50
        }
        
        return winnings
    }
    
    
    
    class func unpackSlotsIntoRows(slots: [[Slot]]) -> [[Slot]] {
        
        var slotRow:[Slot] = []
        var slotRow2:[Slot] = []
        var slotRow3:[Slot] = []
        
        for slotArray in slots {
            
            for var index = 0; index < slotArray.count; index++ {
                let slot = slotArray[index]
                
                if index == 0 {
                    slotRow.append(slot)
                }
                else if index == 1 {
                    slotRow2.append(slot)
                }
                else if index == 2 {
                    slotRow3.append(slot)
                }
                else {
                    println("error!")
                }
            }
        }
        
        var slotInRows:[[Slot]] = [slotRow, slotRow2, slotRow3]
        return slotInRows
    }
    
    // Helpers
    
    
    class func checkFlush(slotRow: [Slot]) -> Bool {
        
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        
        if slot1.isRed == true && slot2.isRed == true && slot3.isRed == true {
            return true
        }
        else if slot1.isRed == false && slot2.isRed == false && slot3.isRed == false {
            return true
        }
        else {
            return false
        }
        
    }
    
    
    class func checkStraight(slotRow: [Slot]) -> Bool {
        
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        
        if slot1.value == slot2.value - 1 && slot1.value == slot3.value - 2 {
            return true
        }
        else if slot1.value == slot2.value + 1 && slot1.value == slot3.value + 2 {
            return true
        }
        else {
            return false
        }
        
    }
    
    
    class func checkThreeOfKind(slotRow: [Slot]) -> Bool {
        
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        
        if slot1.value == slot2.value && slot1.value == slot3.value {
            return true
        }
        else {
            return false
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}