//
//  ViewController.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class NodesFieldViewController: NSViewController {

    @IBOutlet var skView: SKView!
	
	var _modelController:NodesModelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
    }
	
	func putOnScene(scene:SKScene) {
		scene.scaleMode = .aspectFill
		// Present the scene
		if let view = self.skView {
			view.presentScene(scene)
			
			view.ignoresSiblingOrder = true
			
			view.showsFPS = true
			view.showsNodeCount = true
		}
	}
}

