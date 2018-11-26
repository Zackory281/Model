//
//  GUIController.swift
//  Model
//
//  Created by Zackory Cramer on 11/11/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class GUIController : NSObject, GUIDelegate {
	
	private var _scene: NodeScene
	private var _nodes = Dictionary<Int, UINode>()
	private var _setting: UISetting
	private var _overlayController: UIOverlayController
	
	// MARK: GUIDelegate stub
	func addNode(_ nodeInterface: NodeIterface) {
		guard _nodes[nodeInterface.hash] == nil else {
			print("adding an existing item:", nodeInterface)
			return
		}
		var uiNode: UINode!
		switch nodeInterface.nodeType{
		case .Path:
			uiNode = UIPathNode.init(CGFloat(nodeInterface.point.0 + 1), CGFloat(nodeInterface.point.1 + 1), orientations: nodeInterface.orientations!, nodeInterface.color!)
		case .Shape:
			uiNode = UIShapeNode.init(CGFloat(nodeInterface.point.0 + 1), CGFloat(nodeInterface.point.1 + 1), orientations: nodeInterface.orientations!, nodeInterface.color!)
		case .Projectile:
			uiNode = UIProjectileNode(CGFloat(nodeInterface.point.0 + 1), CGFloat(nodeInterface.point.1 + 1), radius: CGFloat(nodeInterface.radius!))
		case .Geometry:
			uiNode = UIGeometryNode(nodeInterface: nodeInterface)
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
	
	func removeNode(_ hash: Int) {
		guard let node = _nodes.removeValue(forKey: hash) else {
			print("The node to remove doesn't exist.");
			return
		}
		node.removeFromParent()
	}
	
	func dislayTickNumber(_ tick: Int, _ success: Bool) {
		if tick % 60 == 0 || !(_setting[.AutoTick] as! Bool) {
			_scene.changeTick(tick, success)
		}
		//_scene.changeTick(tick, success)
	}
	
	init(scene: NodeScene, setting: UISetting, overlayController: UIOverlayController) {
		_scene = scene
		_setting = setting
		_overlayController = overlayController
	}
	
	func display(_ string: String) {
		_overlayController.display(.Display(string))
	}
	
	func clearAllNodes() {
		for node in _nodes.values {
			node.removeFromParent()
		}
		_nodes.removeAll()
	}
}
