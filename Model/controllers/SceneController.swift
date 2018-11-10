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
			uiNode = UIPathNode.init(CGFloat(nodeInterface.point.0 + 1), CGFloat(nodeInterface.point.1 + 1), orientations: nodeInterface.orientations, nodeInterface.color)
		case .Shape:
			uiNode = UIShapeNode.init(CGFloat(nodeInterface.point.0 + 1), CGFloat(nodeInterface.point.1 + 1), orientations: nodeInterface.orientations, nodeInterface.color)
		}
		_nodes[nodeInterface.hash] = uiNode
		_scene.addChild(uiNode)
	}
	
	func updatePosition(_ nodeUpdateInterface: NodeUpdateIterface) {
		guard let node = _nodes[nodeUpdateInterface.hash] else {
			print("updaing a non-existant item")
			return
		}
		node.update(interface: nodeUpdateInterface)
	}
	
	func dislayTickNumber(_ tick: Int, _ success: Bool) {
		if !_autoTick {
			_scene.changeTick(tick, success)
		}
		//_scene.changeTick(tick, success)
	}
	
	func keyClicked(_ c: String) {
		switch c {
		case "c":
			for node in _nodes.values {
				node.removeFromParent()
			}
			_nodes.removeAll()
			return
		case "a":
			_autoTick = !_autoTick
			return
		default:
			break
		}
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
			_nodesModelController?.clickToggleNode(psx, psy, type: .Shape)
			return
		}
		if let b = _nodesModelController?.addNodes(psx, psy, x / PATH_WIDTH, y / PATH_WIDTH), b {
			return
		}
		
//		let code = UnicodeScalar.init("s")!.utf16.first!
//		if _scene.keyIsDown(code) {
//			_nodesModelController?.clickToggleNode(psx, psy, type: .Shape)
//		} else {
//			_nodesModelController?.clickToggleNode(psx, psy, type: .Shape)
//		}
	}
	
	func update() {
		if _autoTick {
			_nodesModelController?.tick()
		}
	}
	
	weak var _nodesModelController:NodesModelController?
	
	init(scene:NodeScene) {
		self._scene = scene
	}
	
	func getScene() -> SKScene {
		return _scene
	}
	
	private var _autoTick = true
}

let KEY_CODES:Dictionary<String, (NodesModelController) -> () -> ()> = [
	"t" : NodesModelController.tick,
	"l" : NodesModelController.preloadModel,
]
