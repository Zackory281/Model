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
	
	private var _nodes = Dictionary<Int, UINode>()
	
	// MARK: GUIDelegate stub
	func addPathNode(_ nodeInterface: NodeIterface) {
		guard _nodes[nodeInterface.hash] == nil else {
			print("adding an existing item")
			return
		}
		var uiNode: UINode!
		switch nodeInterface.nodeType{
		case .Path:
			uiNode = UIPathNode.init(nodeInterface.x + 1, nodeInterface.y + 1, orientations: nodeInterface.orientations, nodeInterface.color)
		case .Shape:
			uiNode = UIShapeNode.init(nodeInterface.x + 1, nodeInterface.y + 1, orientations: nodeInterface.orientations, nodeInterface.color)
		}
		_nodes[nodeInterface.hash] = uiNode
		_scene.addChild(uiNode)
	}
	
	func updatePosition(_ nodeUpdateInterface: NodeUpdateIterface) {
		guard let node = _nodes[nodeUpdateInterface.hash] else {
			print("updaing a non-existant item")
			return
		}
		node.update(nodeUpdateInterface.x + 1, nodeUpdateInterface.y + 1, nodeUpdateInterface.color)
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
		guard withinSquare else { return }
		_nodesModelController?.clickToggleNode(psx, psy, type: .Shape)
//		let code = UnicodeScalar.init("s")!.utf16.first!
//		if _scene.keyIsDown(code) {
//			_nodesModelController?.clickToggleNode(psx, psy, type: .Shape)
//		} else {
//			_nodesModelController?.clickToggleNode(psx, psy, type: .Shape)
//		}
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
