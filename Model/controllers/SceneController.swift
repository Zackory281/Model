//
//  SceneController.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import SpriteKit

class SceneController : NSObject, GUIDelegate, SKSceneDelegate, SceneInputDelegate {
	
	private let _scene:SKScene
	
	private var px, py: Int!
	private var psx, psy: Int!
	private var withinSquare: Bool!
	
	func addPathNode(_ x: Int, _ y: Int) {
		_scene.addChild(getPathNodeAt(x, y))
	}
	
	func mouseDragged(_ x: Int, _ y: Int) {
		if withinSquare && (psx, psy) != (x / PATH_WIDTH + 1, y / PATH_WIDTH + 1) {
			withinSquare = false
		}
	}
	
	func mouseDown(_ x: Int, _ y: Int) {
		withinSquare = true
		(px, py) = (x, y)
		(psx, psy) = (x / PATH_WIDTH + 1, y / PATH_WIDTH + 1)
	}
	
	func mouseUp(_ x: Int, _ y: Int) {
		if withinSquare {
			_nodesModelController?.clickToggleNode(psx, psy)
		}
	}
	
	func update(_ currentTime: TimeInterval, for scene: SKScene) {
		_nodesModelController?.tick()
	}
	
	weak var _nodesModelController:NodesModelController?
	
	init(scene:SKScene) {
		self._scene = scene
	}
	
	func getScene() -> SKScene {
		return _scene
	}
}
