//
//  ViewController.swift
//  FlappyBird
//
//  Created by 吉谷拓海 on 2020/06/21.
//  Copyright © 2020 takumi.yoshiya. All rights reserved.
//

import UIKit
import SpriteKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let skView = self.view as! SKView
        
        skView.showsFPS = true
        
        skView.showsNodeCount = true
        
        let scene = GameScene(size:skView.frame.size)
        
        skView.presentScene(scene)
        
        
    }
    override var prefersStatusBarHidden: Bool{
        get {
            return true
        }
    }

}

