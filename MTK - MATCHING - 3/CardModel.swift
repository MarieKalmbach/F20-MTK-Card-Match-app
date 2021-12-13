//
//  CardModel.swift
//
//  Created by BPSTIL - Swift - Mrs. K on 11/11/20.
//  Copyright © 2020 Kalmbach. All rights reserved.
//

import Foundation

class CardModel
{
    
    // METHOD - Return an array of n integers that are
    //          random & unique & between min & max
    //
    func getRandomUniqueInts (n:Int, min:Int, max:Int) -> [Int]
    {
        // create an empty array of integers
        var generatedNums = [Int]()
        
        var count = 0
        
        // generate random numbers until n unique ones are found
        //
        while count < n
        {
            let randomNumber = Int.random(in: min...max)
            print("random # = \(randomNumber)")
            
            if !generatedNums.contains(randomNumber)
            {
                generatedNums += [randomNumber]
                count += 1
            }
            print ("\t count = \(count)\n")
        }
        
        return generatedNums
        
    }//end of getRandomUniqueInts
    
    
    // METHOD - get 8 pairs of random, unique cards
    //
    func getCards() -> [Card]
    {
        print ("-- getting ready to generate 8 random pairs of cards --\n")
        
        // declare empty array
        var generatedCards = [Card]()
        
        
        // get a list of 8 random & unique numbers between 1 & 13
        //
        let numList = getRandomUniqueInts(n: 8, min: 1, max: 13)
        
        
        // generate 8 pairs of cards based on numList
        //
        for num in numList
        {
            // create two new Card objects
            let cardOne = Card()
            let cardTwo = Card()
            
            // set their image names
            cardOne.imageName = "card\(num)"
            cardTwo.imageName = "card\(num)"
            
            // add to the array
            generatedCards += [cardOne, cardTwo]
        }
        
        // arrange the cards in the array in a random order
        generatedCards.shuffle()
        
        // return the array of 8 random pairs of cards
        return generatedCards
        
    }//end of getCards() method
    
}//end of CardModel class
