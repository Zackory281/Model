//
//  GeometryNode.swift
//  Model
//
//  Created by Zackory Cramer on 11/13/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import AppKit

class GeometryNode: NodeAbstract {
	override var _color: NSColor? { get { return .systemRed }}
	var _pointsOccupied: [Point]
	var _geometry: GeometryType
	var _pathNodes: WeakSet<PathNodeAbstract>
	var _health: Float = 1
	override var _type: NodeType { get { return .Geometry } }
	init(anchor: Point, geometry: GeometryType) {
		_pointsOccupied = []
		_geometry = geometry
		_pathNodes = WeakSet<PathNodeAbstract>()
		super.init()
		_point = anchor
		switch geometry {
		case let .Square(width, height):
			for x in 0..<width {
				for y in 0..<height {
					_pointsOccupied.append((anchor.0 + x, anchor.1 + y))
				}
			}
		case let .Custom(points):
			for (x, y) in points {
				_pointsOccupied.append((anchor.0 + x, anchor.1 + y))
			}
		}
	}
	func addOccupiedPathNode(node: PathNodeAbstract) {
		_pathNodes.insert(node)
	}
	deinit {
		print("Geometry node... GONE!!!")
	}
}

enum GeometryType {
	case Square(width: IntC, height: IntC)
	case Custom([Point])
}
