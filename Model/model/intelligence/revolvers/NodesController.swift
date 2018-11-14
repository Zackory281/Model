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
	
	var _pathNodeController: PathNodeController
	var _shapeNodeController: ShapeNodeController
	var _projectileNodeController: ProjectileNodeController
	var _geometryNodeController: GeometryNodeController
	var _nodeMap : NodeMap
	var _queue: GUIQueue
	
	func addNodeAt(_ point: Point, _ type: NodeType) {
		switch type {
		case .Projectile:
			fatalError("Can't add a node from point")
		case .Shape:
			if let pathNode = _pathNodeController.getPathNodeAt(point), pathNode._shapeNode == nil {
				let shapeNode = ShapeNode.init(point, direction: pathNode._directions[safe: 0] ?? .UP, pathNode: pathNode, headNode: nil)
				pathNode._shapeNode = shapeNode
				pathNode._taken = true
				_shapeNodeController.addShapeNode(shapeNode)
			} else {
				fallthrough
			}
		case .Path where type == .Path || type == .Geometry:
			guard let _ = _pathNodeController.addPathNode(at: point) else { return }
		case .Geometry:
			addGeometryNode(GeometryNode(anchor: point, geometry: .Square(width: 3, height: 3)))
		default:
			break
		}
//		if _pathNodeController.getPathNodeAt(point) == nil {
//			guard let _ = _pathNodeController.addPathNode(at: point) else { return }
//		} else if let pathNode = _pathNodeController.getPathNodeAt(point), pathNode._shapeNode == nil {
//			let shapeNode = ShapeNode.init(point, direction: pathNode._directions[safe: 0] ?? .UP, pathNode: pathNode, headNode: nil)
//			pathNode._shapeNode = shapeNode
//			pathNode._taken = true
//			_shapeNodeController.addShapeNode(shapeNode)
//		}
	}
	
	func addNodeAt(_ x: IntC, _ y: IntC, _ type: NodeType) { addNodeAt((x, y), type) }
	
	func addProjectileNode(_ node: ProjectileNode) {
		_projectileNodeController.addProjectile(node)
	}
	
	func addGeometryNode(_ geometry: GeometryNode) {
		if !_geometryNodeController.add(geometry: geometry) {
			print("geometry insertion failed: \(geometry)")
		}
	}
	
	func addPathNodesFromHead(_ head: PathNodeAbstract) {
		let _ = _pathNodeController.addHeadNode(head)
	}
	
	func getNode(at point: Point) -> NodeAbstract? {
		if let node = _pathNodeController.getPathNodeAt(point) {
			return node
		}
		if let node = _shapeNodeController.getShapeNode(at: point) {
			return node
		}
		return nil
	}
	
	func getQueries() -> Set<CustomQuery> {
		var qs = Set<CustomQuery>()
		for n in _shapeNodeController._shapeNodes {
			if n._state == .CanNowMove {
				qs.insert(.ShapeNowMove(n))
			}
		}
		return qs
	}
	
	func tick(_ tick: TickU) {
		_shapeNodeController.tick(tick)
		_projectileNodeController.tick(tick)
		_nodeActionDelegate?.uiAddQueue(_queue)
	}
	
	override init() {
		_queue = GUIQueue()
		_nodeMap = NodeMap(width: 100, height: 100)
		_pathNodeController = PathNodeController(nodeMap: _nodeMap, queue: _queue)
		_shapeNodeController = ShapeNodeController(nodeMap: _nodeMap, queue: _queue)
		_projectileNodeController = ProjectileNodeController(queue: _queue)
		_geometryNodeController = GeometryNodeController(nodeMap: _nodeMap, queue: _queue)
		super.init()
	}
}

protocol NodeControlDelegate: NSObjectProtocol {
	func addNodeAt(_ x: IntC, _ y: IntC, _ type: NodeType)
	func addNodeAt(_ p: Point, _ type: NodeType)
}
