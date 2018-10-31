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
	
	private let _scene:NodeScene
	
	private var px, py: Int!
	private var psx, psy: Int!
	private var withinSquare: Bool!
	
	private var _nodes = Dictionary<Int, UIPathNode>()
	
	// MARK: GUIDelegate stub
	func addPathNode(_ hash: Int, _ x: Int, _ y: Int, orientation: [Direction]) {
		guard _nodes[hash] == nil else {
			print("adding an existing item")
			return
		}
		let uiNode = UIPathNode.init(x + 1, y + 1, orientations: orientation)
		_nodes[hash] = uiNode
		_scene.addChild(uiNode)
	}
	
	func dislayTickNumber(_ tick: Int, _ success: Bool) {
		_scene.changeTick(tick, success)
	}
	
	func keyClicked(_ c: String) {
		guard let nodesModelController = _nodesModelController, let f = KEY_CODES[c] else { return }
		f(nodesModelController)()
	}
	
	func mouseDragged(_ x: Int, _ y: Int) {
		if withinSquare && (psx, psy) != (x / PATH_WIDTH, y / PATH_WIDTH) {
			withinSquare = false
		}
	}
	
	func mouseDown(_ x: Int, _ y: Int) {
		withinSquare = true
		(px, py) = (x, y)
		(psx, psy) = (x / PATH_WIDTH, y / PATH_WIDTH)
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
	
	init(scene:NodeScene) {
		self._scene = scene
	}
	
	func getScene() -> SKScene {
		return _scene
	}
}

let KEY_CODES:Dictionary<String, (NodesModelController) -> () -> ()> = [
	"t" : NodesModelController.tick,
	"l" : NodesModelController.preloadModel,
]
