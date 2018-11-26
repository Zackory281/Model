//
//  NodeTree.swift
//  Model
//
//  Created by Zackory Cramer on 10/29/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

class NodeMap {
	private var _quadTree: GKQuadtree<NodeAbstract>
	
	func contains<T: NodeAbstract>(of type: T.Type, at point: Point) -> Bool {
		let nodes = _quadTree.elements(at: float2(Float(point.0)+0.5, Float(point.1)+0.5))
		return nodes.contains {$0 is T}
	}
	
	func containsCollisionNode(_ node: NodeAbstract) -> Bool {
		let nodes = _quadTree.elements(at: float2(Float(node._point.0)+0.5, Float(node._point.1)+0.5))
		let c = node._category
		return nodes.contains{$0._overlap & c != 0}
	}
	
	func getPatternNodes<T: NodeAbstract, W>(of _: T.Type, at point: Point, from delta: [(IntC, IntC, W)]) -> [(T, W)] {
		var nodes: [(T, W)] = []
		for (dx, dy, d) in delta {
			let first = _quadTree.elements(at: float2(Float(point.0 + dx)+0.5, Float(point.1 + dy)+0.5)).filter{$0 is T}.first
			if let node = first as? T {
				nodes.append((node, d))
			}
		}
		return nodes
	}
	
	func getNodes(left: Point, right: Point) -> [NodeAbstract]
	{
		let quad = GKQuad(quadMin:
			float2(Float(left.0), Float(left.1)),
						  quadMax: float2(Float(right.0), Float(right.1)))
		return _quadTree.elements(in: quad)
	}
	
	func getNodes(at point: Point) -> [NodeAbstract] {
		return _quadTree.elements(at: float2(Float(point.0)+0.5, Float(point.1)+0.5))
	}
	
	func getNodes<T:NodeAbstract>(of _: T.Type, at point: Point) -> [T] {
		return _quadTree.elements(at: float2(Float(point.0)+0.5, Float(point.1)+0.5)).filter{$0 is T} as! [T]
	}
	
	func getNodes(of type: NodeType, at point: Point) -> [NodeAbstract] {
		return _quadTree.elements(at: float2(Float(point.0)+0.5, Float(point.1)+0.5)).filter{$0._type == type}
	}
	
	func add(node: NodeAbstract) {
		guard !_nodeDict.keys.contains(node.hash) else { print("adding a preexisting node in map"); return }
		var set = Set<GKQuadtreeNode>()
		switch node._type {
		case .Shape, .Path:
			let point = node._point
			set.insert(_quadTree.add(node, at: float2(Float(point.0)+0.5, Float(point.1)+0.5)))
		case .Geometry:
			for point in (node as! GeometryNode)._pointsOccupied {
				set.insert(_quadTree.add(node, at: float2(Float(point.0)+0.5, Float(point.1)+0.5)))
			}
		default:
			fatalError("Can't add \(node)")
		}
		_nodeDict[node.hash] = set
	}
	
	func move(node: NodeAbstract) {
		remove(node: node)
		add(node: node)
	}
	
	func remove(node: NodeAbstract) {
		guard let set = _nodeDict.removeValue(forKey: node.hash) else { print("No node to remove in nodemap"); return}
		for qnode in set {
			_quadTree.remove(node, using: qnode)
		}
	}
	
	init(width: IntC, height: IntC) {
		_quadTree = GKQuadtree<NodeAbstract>.init(boundingQuad: GKQuad(quadMin: float2(0, 0), quadMax: float2(Float(width), Float(height))), minimumCellSize: 0.5)
	}
	
	private var _nodeDict = Dictionary<Int, Set<GKQuadtreeNode>>()
}

let GRID_NEIGHBOR:[(IntC, IntC, Direction)] = [
	(1,0,Direction.RIGHT),
	(0,1,Direction.UP),
	(-1,0,Direction.LEFT),
	(0,-1,Direction.DOWN)]

struct NodeUnit {
	private var _nodes: [NodeAbstract] = []
	var _categoryBit: INTB = 0
	var _collisionBit: INTB = 0
//	init(pathNode: PathNodeAbstract) {
//		_pathNode = pathNode
//	}
//	func add(_ node: NodeAbstract) {
//		_nodes.append(node)
//	}
}
