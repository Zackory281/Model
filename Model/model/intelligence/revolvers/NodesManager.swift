//
//  NodesManager.swift
//  Model
//
//  Created by Zackory Cramer on 11/4/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class NodesController: NSObject, NodeControlDelegate, QueryNodeDelegate{
	
	var _nodeActionDelegate: OutputDelegate? {
		set { _shapeNodeController._nodeActionDelegate = newValue
			_pathNodeController._nodeActionDelegate = newValue }
		get { return _shapeNodeController._nodeActionDelegate ??
			_pathNodeController._nodeActionDelegate }
	}
	
	private var _pathNodeController :PathNodeController = PathNodeController(width: 100, height: 100)
	private var _shapeNodeController :ShapeNodeController = ShapeNodeController()
	
	func addNodeAt(_ x: IntC, _ y: IntC, _ type: NodeType) {
		switch type {
		case .Path:
			guard _pathNodeController.getPathNodeAt(x, y) == nil else {
				print("adding a path node to an existing location \(x), \(y)")
				return
			}
			_pathNodeController.addPathNodeAt(x, y) //TODO: Node linking
			return
		case .Shape:
			guard !_shapeNodeController.hasShapeNodeAt(x, y: y), let pathNode = _pathNodeController.getPathNodeAt(x, y) else {
				print("adding a shape node to an existing location \(x), \(y)")
				return
			}
			let shapeNode = ShapeNode.init(x, y, direction: pathNode.getOrientations()[0], pathNode: pathNode, headNode: nil)
			pathNode.setShapeNode(node: shapeNode)
			_shapeNodeController.addShapeNode(shapeNode)
			return
		}
	}
	
	func addNodeAt(_ p: Point, _ type: NodeType) { addNodeAt(p.0, p.0, type) }
	
	func addPathNodesFromHead(_ head: PathNode) {
		_pathNodeController.addHeadNode(head)
	}
	
	func getQueries() -> Set<CustomQuery> {
		var qs = Set<CustomQuery>()
		for n in _shapeNodeController._shapeNodes {
			qs.insert(.ShapeNowMove(n))
		}
		return qs
	}
}

protocol NodeControlDelegate {
	func addNodeAt(_ x: IntC, _ y: IntC, _ type: NodeType)
	func addNodeAt(_ p: Point, _ type: NodeType)
}
