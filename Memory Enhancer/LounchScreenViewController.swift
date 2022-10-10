//
//  LounchScreenViewController.swift
//  Memory Enhancer
//
//  Created by Asım Altınışık on 8.10.2022.
//

import UIKit

class LounchScreenViewController: UIViewController {
    
    @IBOutlet weak var bestScoreLabel: UILabel!
    
    //This string will be used to update best score label.
    var bestScoreLabelValue = ""
    
    override func viewDidLoad() {
        let defaults = UserDefaults.standard
        //Takes the high score.
        let highScore = defaults.integer(forKey: "HighScore")
        
        //Puts high score into the string
        bestScoreLabelValue = "Best: " + String(highScore)
        
        //Update the best score label.
        bestScoreLabel.text = bestScoreLabelValue
        
        super.viewDidLoad()

    }
}
