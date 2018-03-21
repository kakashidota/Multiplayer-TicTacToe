//
//  ViewController.swift
//  TicTacToeTutorial
//
//  Created by Robin kamo on 2018-03-20.
//  Copyright © 2018 Robin kamo. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var activePlayer = 1 //Cross
    var gameState = [0,0,0,0,0,0,0,0,0]
    var multiGameState : [Int] = []
    var winningCombos = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    var gameIsActive = true
    @IBOutlet weak var lobbyField: UITextField!
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.isHidden = true
        resetBtn.isHidden = true
        

      
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func joinLobbyPressed(_ sender: Any) {
        view.endEditing(true)
        let myDatabase = Database.database().reference(withPath: lobbyField.text!)
        myDatabase.setValue(gameState)
        
        retriveBoard()
        
    }
    
    @IBAction func action(_ sender: AnyObject) {
        let myDatabase = Database.database().reference(withPath: lobbyField.text!)

        
        if gameState[sender.tag - 1] == 0{
            gameState[sender.tag - 1] = activePlayer
            
            if activePlayer == 1 {
                sender.setBackgroundImage(UIImage(named : "cross"), for: UIControlState.normal)
             //   print(sender.tag)
                activePlayer = 2
                myDatabase.setValue(gameState)
                
            } else {
                sender.setBackgroundImage(UIImage(named : "circle"), for: UIControlState.normal)
                activePlayer = 1
                myDatabase.setValue(gameState)
            }
        }
        
        for combination in winningCombos{
            //let myDatabase = Database.database().reference()
            if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]]{
                
                gameIsActive = false
            if gameState[combination[0]] == 1{
                label.isHidden = false
                resetBtn.isHidden = false
                label.text = "Cross won the game!"
                myDatabase.child("Stats").setValue("cross won the game")
            } else{
                label.isHidden = false
                resetBtn.isHidden = false
                label.text = "Circle won the game!"

            }
        }
    
    }
        
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        gameState = [0,0,0,0,0,0,0,0,0]
       // let myDatabase = Database.database().reference()
   //     myDatabase.setValue(gameState)
        gameIsActive = true
        activePlayer = 1
        label.isHidden = true
        resetBtn.isHidden = true
        
        for i in 1...9{
            let button = view.viewWithTag(i) as! UIButton
            button.setBackgroundImage(nil, for: UIControlState.normal)
        }
    }
    
  
    
    func retriveBoard(){
       let myDatabase = Database.database().reference(withPath: lobbyField.text!)
        myDatabase.observe(.childChanged) { (snapshot) in
           
            
            if let snapshotValue = snapshot.value{
                
                if let playerID = snapshotValue as? Int {
                    let pos = snapshot.key
                    if let newPos = Int(pos) {
                       // self.gameState.insert(playerID, at: newPos)
                        self.gameState[newPos] = playerID
                        
                        self.updateBoard(index: newPos, player: playerID)
                        
                        
                    } else {
                        print("FAAKDKAKKKKAKAAAYUUUUUDUCKAFACKAFALKKKATJIGATJAGVASAFA")
                    }
                }
            }
        }
    }
    
    func updateBoard(index: Int, player: Int){
        
        
        let button = view.viewWithTag(index + 1) as? UIButton
        if player == 1 {
            
            button?.setBackgroundImage(#imageLiteral(resourceName: "cross"), for: UIControlState.normal)
        } else if player == 2 {
            button?.setBackgroundImage(#imageLiteral(resourceName: "circle"), for: UIControlState.normal)
        }
        }
    
}
