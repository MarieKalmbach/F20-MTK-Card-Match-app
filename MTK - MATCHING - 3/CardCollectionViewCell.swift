//
//  CardCollectionViewCell.swift
//  MTK - MATCHING - 3
//
//  Created by BPSTIL - Swift - Mrs. K on 11/13/20.
//  Copyright © 2020 Kalmbach. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?  // initially our card will be nil before it is configured
    
    func configureCardCell(card:Card)
    {
        // keep track of the card this card cell represents
        self.card = card
        
        // set the front image view to the image that represents the card
        frontImageView.image = UIImage(named: card.imageName)
        
        
        // make card invisible or visible based on MATCHED status
        //
        if card.isMatched   // so make images INVISIBLE
        {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return  // exit method early, no reason to continue
        }
        else // card is NOT matched, so make images VISIBLE
        {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
            
        
        // reset card image based on "flipped" status
        //
        if card.isFlipped == true
        {
            // show FRONT of card
            flipUp(speed:0)
        }
        else 
        {
            // show BACK of card
            flipDown(speed: 0, delay:0)
        }
        
    }//end of configureCardCell() method
    
    
    
    func flipUp(speed:TimeInterval = 0.5)
    {
        // flip card from BACK to FRONT with animation
        //
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        
        /*
        UIView.transition(      from: backImageView,
                                  to: frontImageView,
                            duration: speed,
                             options: [.showHideTransitionViews,
                                       .transitionFlipFromLeft],
                          completion: nil)
 
        */
        
        // update the cardIsFlipped status
        //
        card?.isFlipped = true
        
    }//end of flipUp() method
    
    
    
    func flipDown(speed:TimeInterval = 0.5,
                  delay:TimeInterval = 0.75
                  )
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay)
        {
            // flip card from FRONT to BACK with animation
            //
            UIView.transition(      from: self.frontImageView,
                                      to: self.backImageView,
                                duration: speed,
                                 options: [.showHideTransitionViews,
                                           .transitionFlipFromLeft],
                              completion: nil)
        }
        
        
        // update the cardIsFlipped status
        //
        card?.isFlipped = false
        
    }//end of flipDown() method
    
    
    func remove()
    {
        // Make the BACK image view invisible
        // by setting the .alpha property (opacity) to 0.
        // This happens instantaeously for the back of card
        // which is OK because back of card is not displayed.
        //
        backImageView.alpha = 0
        
        // For the FRONT image view, make it disappear slowly
        // using an animation with a delay.
        //
        UIView.animate(withDuration: 0.5,
                                  delay: 0.5,
                                options: .curveEaseOut,
                             animations: { self.frontImageView.alpha = 0 },
                             completion: nil
                           )
        
    }//end of remove() method
    
     
}//end of CardCollectionViewCell class
