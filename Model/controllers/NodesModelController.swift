//
//  ModelController.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import AppKit

class NodesModelController :NSObject, NodesModelActionDelegate{
	
	private let _nodesModel:NodesModel
	private weak var _guiDelegate:GUIDelegate?
	
	// Mark: NodesModelActionDelegate stubs
	func uiAddNodes(_ nodes: [Node]) {
		guard let _guiDelegate = _guiDelegate else { return }
		for node in nodes {
			var s:NodeIterface!
			switch (node._type) {
			case .Shape:
				let shapeNode = (node as! PathNodeAbstract)
				s = NodeIterface(point: node._point, orientations: [], hash: (node as! NSObject).hash, nodeType: node._type, color: shapeNode._color ?? .white)
			default:
				let pathNode = (node as! PathNodeAbstract)
				s = NodeIterface(point: node._point, orientations: pathNode._directions, hash: (node as! NSObject).hash, nodeType: node._type, color: pathNode._color ?? .white)
			}
			_guiDelegate.addPathNode(s)
		}
	}
	
	func uiUpdateNodes(_ nodes: [Node]) {
		guard let _guiDelegate = _guiDelegate else { return }
		for node in nodes {
			_guiDelegate.updatePosition(NodeUpdateIterface(point: node._point,color: node._color ?? .white, hash: (node as! NSObject).hash))
		}
	}
	
	func clickToggleNode(_ x: Int, _ y: Int, type: NodeType) -> Void {
		_nodesModel.addNodeAt(IntC(x), IntC(y), type)
	}
	
	func tick() {
		let success = _nodesModel.tick()
		_guiDelegate?.dislayTickNumber(Int(_nodesModel.getTick()), success)
	}
	
	func preloadModel() {
		_nodesModel.loadModel()
	}
	
	init(nodesModel:NodesModel, guiDelegate:GUIDelegate) {
		_nodesModel = nodesModel
		_guiDelegate = guiDelegate
		super.init()
		_nodesModel._modelActionDelegate = self
	}
}

protocol GUIDelegate: NSObjectProtocol {
	
	func addPathNode(_ nodeInterface: NodeIterface)
	func updatePosition(_ nodeUpdateInterface: NodeUpdateIterface)
	func dislayTickNumber(_ tick: Int, _ success: Bool)
}

struct NodeIterface {
	let point: Point
	let orientations: [Direction]
	let hash: Int
	let nodeType: NodeType
	let color: NSColor
}

struct NodeUpdateIterface {
	let point: Point
	let color: NSColor
	let hash: Int
}

enum NodeType {
	case Path
	case Shape
}
