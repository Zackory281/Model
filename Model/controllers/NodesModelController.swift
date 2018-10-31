//
//  ModelController.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class NodesModelController :NSObject, NodesModelActionDelegate{
	
	private let _nodesModel:NodesModel
	private weak var _guiDelegate:GUIDelegate?
	
	// Mark: NodesModelActionDelegate stubs
	func uiAddPathNodes(_ nodes: [Node]) {
		guard let _guiDelegate = _guiDelegate else { return }
		for node in nodes {
			let p = node.getPoint()
			let s = NodeIterface(x: Float(p[0]), y: Float(p[1]), orientations: node.getOrientations(), hash: (node as! NSObject).hash, nodeType: node.getType())
			_guiDelegate.addPathNode(s)
		}
	}
	
	func clickToggleNode(_ x: Int, _ y: Int) -> Void {
		_nodesModel.addPathNodeAt(Int16(x), Int16(y))
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
	func dislayTickNumber(_ tick: Int, _ success: Bool)
}

struct NodeIterface {
	let x: Float
	let y: Float
	let orientations: [Direction]
	let hash: Int
	let nodeType: NodeType
}

enum NodeType {
	case Path
	case Shape
}
