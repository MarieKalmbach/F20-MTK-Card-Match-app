//
//  ViewController.swift
//
//  MTK - MATCHING - 3 - WORKING COPY - Nov. 12
//
// >>>>>>> at beginning - able to generate 8 random pairs
//
//  Created by BPSTIL - Swift - Mrs. K on 11/11/20.
//  Copyright © 2020 Kalmbach. All rights reserved.
//

import UIKit

class ViewController:
        UIViewController,
        UICollectionViewDataSource,
        UICollectionViewDelegate
{
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // declare properties of View Controller class
    //
    var model = CardModel()
    
    var cardsArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?
    
    var timer: Timer?   // initially will be nil
    
    // time to play = 1 minute (60 sec.) as milliseconds
    var milliseconds: Int = 60 * 1000
    
    var soundPlayer: SoundManager = SoundManager()
    
    
    // METHOD: view Did Load
    //
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        print("calling getCards method")
        
        cardsArray = model.getCards()
        
        // set the ViewController as the "dataSource" and the "delegate"
        // of the CollectionView
        //
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // initialize the game timer
        //
        timer = Timer.scheduledTimer(timeInterval: 0.001,
                                           target: self,
                                         selector: #selector(timerFired),
                                         userInfo: nil,
                                          repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
        
    }//end of viewDidLoad() method
    
    
    
    // METHOD: view Did Appear
    //
    override func viewDidAppear(_ animated: Bool)
    {
        // play the shuffle sound
        //
        soundPlayer.playSound(effect: .shuffle)
        
    }//end of viewDidAppear method
    
    
    
    // MARK: - Timer Methods
    
    
    // METHOD: timer Fired
    //
    @objc func timerFired()
    {
        // decrement the number of milliseconds left by one millisecond
        //
        milliseconds -= 1
        
        // update the timer label
        //
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format:"Time Remaining: %.2f", seconds)
        
        // stop timer if it reaches zero
        //
        if milliseconds == 0
        {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            // see if user matched all the pairs
            //
            checkForGameEnd()
            
        }
        
    }//end of timerFired() method
    
    
    
    // MARK: - Collection View Delegate Methods
    
    ///  ??? confusing that all the methods are called "collectionView"
    ///  ??? The second parameter seems to indicate purpose of method
    ///  ??? Is this the idea of "OVERLOADED" methods in Obj. Or. Prog?
    
    
    // --- METHOD: "number Of Items In Section" ---
    //
    func collectionView
        (_                          collectionView: UICollectionView,
           numberOfItemsInSection          section: Int)    -> Int
    {
        // return number of cards to be displayed
        //
        return cardsArray.count
        
    }//end of "numberOfItemsInSection" method
    
    
    
    // --- METHOD: "Cell For Item At" ---
    //
    func collectionView
        (_              collectionView: UICollectionView,
         cellForItemAt       indexPath: IndexPath)          -> UICollectionViewCell
    {
        // get a cell by using the memory-recycling method, dequeueReusableCell(),
        // and cast the cell returned as a CardCollectionViewCell type
        // (This is the customized CollectionViewCell we defined earlier.)
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        /*-----------------------------------------------------
        // This code gets moved to "willDisplay" method below.
        //-----------------------------------------------------
        // get the card from the cards array
        //
        let card =  cardsArray[indexPath.row]
        
        // configure that Card Cell
        //
        cell.configureCardCell(card: card)
        -------------------------------------------------------*/
        
        // return the cell
        return cell

    }//end of cellForItemAt method
    

    
    // --- METHOD: "will Display" cell ---
    //
    func collectionView(_           collectionView: UICollectionView,
                        willDisplay           cell: UICollectionViewCell,
                        forItemAt        indexPath: IndexPath)
    {
        
        // Configure state of cell based on card properties
        let cardCell = cell as? CardCollectionViewCell
        
        // Get the current card from the card array
        let card = cardsArray[indexPath.row]
        
        // Finish configuring the cell
        cardCell?.configureCardCell(card: card)
    
    }//end of willDisplay method

    
    
    // --- METHOD: "did Select Item At" - respond to card TAP
    //
    func collectionView(_               collectionView: UICollectionView,
                        didSelectItemAt      indexPath: IndexPath)
    {
        // If there is no time remaining, exit immediately.
        // Do not allow any further user interaction.
        //
        if milliseconds <= 0
        {
            return      // exit immediately
        }
        
        // get a reference to the card that was tapped
        //
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // use "optional chaining" to flip card UP,
        // but only flip UP card if it is NOT flipped and NOT matched
        //
        if  cell?.card?.isFlipped == false && cell?.card?.isMatched == false
        {
            cell?.flipUp()
            
            // play the card flip sound effect
            //
            soundPlayer.playSound(effect: .flip)
        }
        
        
        // Was this the FIRST or SECOND card flipped?
        //
        if firstFlippedCardIndex == nil
        {
            // This is the FIRST flipped card,
            // so keep a record of which card was flipped first.
            //
            firstFlippedCardIndex = indexPath
        }
        else
        {
            // This is the SECOND flipped card,
            // so run card-compare logic
            //
            checkForMatch(indexPath)
        }
        
    }//end of didSelectItemAt method (respond to card TAP)
    
    

    //MARK: - Game Logic Methods
    
    
    // --- METHOD: "check For Match"
    //
    func checkForMatch(_ secondFlippedCardIndex:IndexPath)
    {
        // get first and second flipped cards using indices
        //
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // get card collection view cells for cards 1 & 2
        //
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // See if card images MATCH for FIRST & SECOND cards
        //
        if cardOne.imageName == cardTwo.imageName
        {
            // Flipped cards MATCH!
            
            // play mathched pair sound effect
            //
            soundPlayer.playSound(effect: .match)
            
            // Set the status flags and remove them.
            //
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Did user just match the LAST pair?
            //
            checkForGameEnd()
        }
        else
        {
            // Flipped cards DO NOT match.
            
            // play mathched pair sound effect
            //
            soundPlayer.playSound(effect: .noMatch)
            
            // Flip cards back down
            //
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
            // Reset the status flags
            //
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
        }
        
        // reset the firstFlippedCardIndex property
        //
        firstFlippedCardIndex = nil 
        
    }//end of checkForMatch() method
    
    
    
    // METHOD: Check For Game End
    //
    func checkForGameEnd()
    {
        var hasWon = true
        
        for card in cardsArray
        {
            if card.isMatched == false
            {
                // user has NOT yet won
                hasWon = false
                break           //exit loop immediately
            }
        }//end of loop through cards checking for unmatched card
        
        if hasWon
        {
            // User won the game!  All pairs matched!
            //
            showAlert(title: "Congrats!", message: "You won!")
            
            // stop the timer
            //
            timerLabel.textColor = UIColor.blue
            timer?.invalidate()
        }
        else  // User had not yet won.
        {
            // User still has some unmatched pairs.
            // Is there still time remaining or is game over?
            //
            if milliseconds <= 0
            {
                showAlert(  title:"Sorry, time is up!",
                          message: "Better luck next time.")
                
            }//end of check for NO MORE TIME is left
            
        }//end of USER STILL HAS UNMATCHED PAIRS code
        
    }//end of checkForGameEnd() method
    
    
    
    //METHOD: show Alert -- win or lose message
    //
    func showAlert(title:String, message:String)
    {
        // create the alert
        //
        let alert = UIAlertController(title: title,
                                    message: message,
                             preferredStyle: .alert)
        
        // define an OK-button so that user can dismiss the alert
        //
        let OKaction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        
        // add this OK-button the the alert
        //
        alert.addAction(OKaction)
        
        // display the alert
        //
        present(alert, animated: true, completion: nil)
        
    }//end of showAlert() method
    
    
}//end of ViewController class
