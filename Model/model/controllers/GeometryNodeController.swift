//
//  GeometryNodeController.swift
//  Model
//
//  Created by Zackory Cramer on 11/13/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class GeometryNodeController {
	
	var _nodeMap: NodeMap
	var _geometryNodes: Set<GeometryNode>
	private weak var _queue: GUIQueue?
	
	func remove(_ node: GeometryNode) {
		_nodeMap.remove(node: node)
		for path in node._pathNodes {
			path._taken = false
		}
		_geometryNodes.remove(node)
		_queue?.remove(node)
	}
	func add(geometry: GeometryNode) -> Bool {
		var pathNodesInvolved = Set<PathNodeAbstract>()
		for point in geometry._pointsOccupied {
			let node = _nodeMap.getNodes(at: point)
			for path in (node.filter({$0 is PathNodeAbstract}) as! [PathNodeAbstract]) {
				pathNodesInvolved.insert(path)
				if path._taken {
					return false
				}
			}
			if !node.filter({$0 is ShapeNode}).isEmpty {
				return false
			}
			if !node.filter({$0 is GeometryNode}).isEmpty {
				return false
			}
		}
		for path in pathNodesInvolved {
			path._taken = true
			path._ocNode = geometry
			geometry.addOccupiedPathNode(node: path)
		}
		_nodeMap.add(node: geometry)
		_queue?.add(node: geometry)
		_geometryNodes.insert(geometry)
		return true
	}
	
	func tick(_ tick: TickU) {
		var toRemove = Set<GeometryNode>()
		for node in _geometryNodes {
			if node._health <= 0 {
				toRemove.insert(node)
			}
		}
		for rem in toRemove {
			remove(rem)
		}
	}
	
	init(nodeMap: NodeMap, queue: GUIQueue) {
		_queue = queue
		_nodeMap = nodeMap
		_geometryNodes = Set<GeometryNode>()
	}
}
