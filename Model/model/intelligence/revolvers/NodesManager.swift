//
//  NodesManager.swift
//  Model
//
//  Created by Zackory Cramer on 11/4/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class NodesController: NSObject, NodeControlDelegate, QueryNodeDelegate{
	
	weak var _nodeActionDelegate: OutputDelegate?
	
	private var _pathNodeController :PathNodeController = PathNodeController(width: 100, height: 100)
	private var _shapeNodeController :ShapeNodeController = ShapeNodeController()
	
	func addNodeAt(_ x: IntC, _ y: IntC, _ type: NodeType) {
		var addNodes: [Node] = []
		var updateNodes: [Node] = []
		switch type {
		case .Path:
			guard let nodeIns = _pathNodeController.addPathNode(SerialPathNode(x, y)) else { return }
			addNodes.append(nodeIns) //TODO: Node linking
			break
		case .Shape:
			guard !_shapeNodeController.hasShapeNodeAt(x, y: y), let pathNode = _pathNodeController.getPathNodeAt(x, y) else {
				print("adding a shape node to an existing location \(x), \(y), or have to pathnode to add to")
				break
			}
			let shapeNode = ShapeNode.init(x, y, direction: pathNode.getOrientations()[0], pathNode: pathNode, headNode: nil)
			pathNode.setShapeNode(node: shapeNode)
			_shapeNodeController.addShapeNode(shapeNode)
			addNodes.append(shapeNode)
			updateNodes.append(pathNode)
			break
		}
		if !addNodes.isEmpty {
			_nodeActionDelegate?.uiAddNodes(nodes: addNodes)
		}
		if !updateNodes.isEmpty {
			_nodeActionDelegate?.uiUpdateNodes(nodes: updateNodes)
		}
	}
	
	func addNodeAt(_ p: Point, _ type: NodeType) { addNodeAt(p.0, p.0, type) }
	
	func advance(_ node: ShapeNode) {
		let oldPath = node.getPathNode()!
		
		node.getPathNode()!.liftShapeNode(node: node)
		let newPathNode = node.getPathNode()!.next(for: PathNodeMeta(direction: node.getDirection()))!
		node.setPathNode(newPathNode)
		_shapeNodeController.move(node)
		newPathNode.setShapeNode(node: node)
		_nodeActionDelegate?.uiUpdateNodes(nodes: [node, oldPath, node.getPathNode()!])
	}
	
	func addPathNodesFromHead(_ head: PathNodeAbstract) {
		let ups = _pathNodeController.addHeadNode(head)
		guard !ups.isEmpty else { return }
		_nodeActionDelegate?.uiAddNodes(nodes: ups)
	}
	
	func getQueries() -> Set<CustomQuery> {
		var qs = Set<CustomQuery>()
		for n in _shapeNodeController._shapeNodes {
			qs.insert(.ShapeNowMove(n))
		}
		return qs
	}
	
	func tick(_ tick: Int16) {
		
	}
}

protocol NodeControlDelegate: NSObjectProtocol {
	func addNodeAt(_ x: IntC, _ y: IntC, _ type: NodeType)
	func addNodeAt(_ p: Point, _ type: NodeType)
	func advance(_ node: ShapeNode)
}
