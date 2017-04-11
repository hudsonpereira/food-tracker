//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Hudson Pereira on 10/04/17.
//  Copyright © 2017 Hudson Pereira. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            self.updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            self.setupButtons()
        }
    }
    @IBInspectable var starCount:Int = 5 {
        didSet {
            self.setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setupButtons()
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        
        // Clear any existing buttons
        for button in self.ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        self.ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<self.starCount {
            // Create the button
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.selected, .highlighted])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: self.starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: self.starSize.width).isActive = true
            
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            self.addArrangedSubview(button)
            
            // Add the new button to the rating button array
            self.ratingButtons.append(button)
        }
        
        self.updateButtonSelectionStates()
    }
    
    //MARK: Button Action
    func ratingButtonTapped(button: UIButton) {
        guard let index = self.ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        let selectedRating = index + 1
        
        if selectedRating == self.rating {
            self.rating = 0
        } else {
            self.rating = selectedRating
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in self.ratingButtons.enumerated() {
            button.isSelected = index < rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            let valueString: String?
            
            switch rating {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 start set."
            default:
                valueString = "\(rating) stars set."
            }
            
            //Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
