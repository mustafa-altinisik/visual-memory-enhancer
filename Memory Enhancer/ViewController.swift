//
//  ViewController.swift
//  Memory Enhancer
//
//  Created by Asım Altınışık on 5.10.2022.
//

import UIKit
import AVFoundation
import AudioToolbox



class ViewController: UIViewController {

    //Connecting main screen elements with code.
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var newRoundButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fifthButton: UIButton!
    @IBOutlet weak var sixthButton: UIButton!
    
    //The array below is used to keep the correct order of icons, will be shuffled later.
    var correctOrderArray = [0, 1, 2, 3, 4, 5];
    
    //arrayIndex will be used in comparing correctOrderArray and userAnswerArray's corresponding indexes.
    var arrayIndex = 0
    
    //wrongTapCount is used to track wrong taps in a round.
    var wrongTapCount = 0
    
    //Variables below are used to track score and round.
    var score = 0
    var round = 1
    
    //healthLabelValue will be used to keep the string to be printed on healthLabel
    var healthLabelValue = ""
    
    var isGameContinuing = true;
    
    //initialTime is the duration of the first round, will be shortened.
    var initialTime = 1.0
    
    //temporaryIndex will be used to animate icons in order.
    var temporaryIndex = 0
    
    //isFinishedFlag will be used to control animation of icons.
    var isFinishedFlag = false
    

    override func viewDidLoad() {
        //When main screen refreshes, new game button will be hidden and labels will be printed with updated values.
        newGameButton.alpha = 0
        newRoundButton.alpha = 0
        isGameContinuing = true
        displayHealth()
        scoreLabel.text = "Score: " + String(score)
        roundLabel.text = "Round " + String(round)
        
        super.viewDidLoad()
        
        //Shuffles the correct order array.
        correctOrderArray.shuffle()
        
        //All icons are hidened.
        firstButton.alpha = 0
        secondButton.alpha = 0
        thirdButton.alpha = 0
        fourthButton.alpha = 0
        fifthButton.alpha = 0
        sixthButton.alpha = 0
        
        //time variable is the duration of a round, it is shortened as game continues.
        let time: Double = initialTime * 6 + initialTime*0.5;

        DispatchQueue.main.asyncAfter(deadline: .now() + initialTime*0.5){
            self.showIconsWithAnimation(order: self.correctOrderArray, duration: self.initialTime)
        }
        //Make all icons after animation.
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.firstButton.alpha = 1;
            self.secondButton.alpha = 1;
            self.thirdButton.alpha = 1;
            self.fourthButton.alpha = 1;
            self.fifthButton.alpha = 1;
            self.sixthButton.alpha = 1;
        }
    }

    @IBAction func newGameButtonPressed(_ sender: Any) {
        //Make the new game button invisible and call newGame function.
        newGameButton.alpha = 0
        newGame()
    }
    
    @IBAction func newRoundButtonPressed(_ sender: Any) {
        newRoundButton.alpha = 0
        newRound()
    }
    
    //We need independent functions for all buttons, they all call the same function with their icon number.
    @IBAction func firstButtonPressed(_ sender: Any) {
        iconPressed(whichButton: 0)
    }
    
    @IBAction func secondButtonPressed(_ sender: Any) {
        iconPressed(whichButton: 1)
    }
    
    @IBAction func thirdButtonPressed(_ sender: Any) {
        iconPressed(whichButton: 2)
    }
    
    @IBAction func fourthButtonPressed(_ sender: Any) {
        iconPressed(whichButton: 3)
    }
    
    @IBAction func fifthButtonPressed(_ sender: Any) {
        iconPressed(whichButton: 4)
    }
    
    @IBAction func sixthButtonPressed(_ sender: Any) {
        iconPressed(whichButton: 5)
    }
    
    //This function is called when an icon is pressed.
    //Takes button id as parameter.
    func iconPressed(whichButton: Int){
        //It is possible to press buttons if the game continues.
        if(isGameContinuing){
            //If round is not ended.
            if(arrayIndex < 6){
                if(correctOrderArray[arrayIndex] == whichButton){
                    //User tapped the correct icon.
                    //Makes a weak vibration.
                    AudioServicesPlaySystemSound(1519)
                    //Increase the score and update the label.
                    score+=1
                    scoreLabel.text = "Score: " + String(score);
                }else{
                    //User tapped the wrong icon.
                    //Makes a strong vibration.
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    //Increases the wrong tap count and updates the health label by calling displayHealth function.
                    wrongTapCount+=1
                    displayHealth()
                    //If the user if out of health points, terminates the game.
                    if(wrongTapCount > 6){
                        //Disables pressing icons.
                        isGameContinuing = false
                        gameOver()
                        return
                    }
                }
                arrayIndex+=1
            }
            //End of the round.
            if(arrayIndex == 6){
                //Disables tapping pressing icons.
                isGameContinuing = false
                //Makes icons invisible when round ends.
                firstButton.alpha = 0
                secondButton.alpha = 0
                thirdButton.alpha = 0
                fourthButton.alpha = 0
                fifthButton.alpha = 0
                sixthButton.alpha = 0
                //Updating main label.
                mainLabel.text = "Round is over."
                newRoundButton.alpha = 1
                return
            }
        }
    }
    
    //This function is used to update health label.
    func displayHealth(){
        var healthLabelValue = "";
        //Number of red hearts.
        let health = 7 - wrongTapCount
        //Number of black hearts.
        let crossCount = 7 - health
        //Adds red hearts to string.
        if(health > 0){
            for _ in 1...health {
                healthLabelValue += "❤️"
            }
        }
        //Concatenate black hearts to string.
        if(crossCount > 0){
            for _ in 1...crossCount {
                healthLabelValue += "🖤"
            }
        }
        //Updates health label with new string.
        healthLabel.text = healthLabelValue;
    }
    
    //This function is used to start a new round.
    func newRound(){
        //Clear the main label.
        mainLabel.text = ""
        if(wrongTapCount < 7){
            //If user still has heart points.
            temporaryIndex = 0
            //Makes the next round faster by increaing initialTime
            initialTime = initialTime * 0.90
            arrayIndex = 0
            round+=1
            //Refreshes the main screen.
            viewDidLoad()
            return
        }else{
            //If user has no heart points, game is over.
            temporaryIndex = 0
            gameOver()
        }
    }
    
    //This function is used to terminate the game.
    func gameOver(){
        //This string will be assigned to mainLabel later.
        var mainLabelText = "Game over !"
        //Adds another line if it is the new high score.
        if(setNewHighScore(scoreToBeChecked: score)){
            mainLabelText += "\nNew high score: " + String(score)
        }
        //Updates main label.
        mainLabel.text = mainLabelText
        //Disables pressing icons.
        isGameContinuing = false
        //Makes the new game button visible.
        newGameButton.alpha = 1
    }
    
    //This function is used to start a new game.
    func newGame(){
        //Sets many values to their defaults.
        temporaryIndex = 0
        initialTime = 1.0
        round = 0
        score = 0
        arrayIndex = 0
        wrongTapCount = 0
        isGameContinuing = true
        displayHealth()
        mainLabel.text = ""
        //Refreashes the main screen.
        viewDidLoad()
    }
    

    //This function is used to show icons in order.
    //Takes two parameters; order is shuffled version of icon's correct order, duration is the suration of each icon's blink.
    func showIconsWithAnimation(order: [Int], duration: Double){
        //Creating a temporary UI Button
        var temporaryButton = UIButton()
        
        //Traverses whole array.
        //temporaryIndex is increased at the end of each iteration.
        switch(order[temporaryIndex]){
        case 0:
            temporaryButton = firstButton;
            break
        case 1:
            temporaryButton = secondButton;
            break
        case 2:
            temporaryButton = thirdButton;
            break
        case 3:
            temporaryButton = fourthButton;
            break
        case 4:
            temporaryButton = fifthButton;
            break
        case 5:
            temporaryButton = sixthButton;
            break
        default:
            break
        }
        
        //Animating a single icon.
        UIView.animate(withDuration: TimeInterval(duration)) {
                temporaryButton.alpha = 1;
                temporaryButton.alpha = 0;
            } completion: { _ in
                //A single icon's animation is done, increase the index.
                self.temporaryIndex += 1
                if(self.temporaryIndex < 6){
                    //Still have some icons to be animated.
                    self.showIconsWithAnimation(order: order, duration: duration)
                }else{
                    //End of the traverse.
                    self.isFinishedFlag = true;
                    return ;
                }
            }

    }
    
    //This function is used to check if the score is higher than the current higher score.
    //If it is higher, makes it the new high score and sets it as userDefault value.
    //Takes the score to be checked
    //Returns true if a new high score is set.
    func setNewHighScore(scoreToBeChecked: Int) -> Bool{
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: "HighScore")
        
        if scoreToBeChecked > highScore {
            //It is the new high score.
            defaults.set(scoreToBeChecked, forKey: "HighScore")
            return true
        }else{
            //It is not the new high score.
            return false
        }
    }
    
    
    //Three functions below are for portrait mode only orientation.
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}

