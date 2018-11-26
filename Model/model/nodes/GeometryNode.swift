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
		case let .Triangle(points):
			let p1 = points[0]
			let p2 = points[1]
			let p3 = points[2]
			let dy = abs(p3.1 - p2.1)
//			for dx in 0...p2.0 {
//
//				let s: StrideTo<IntC>!
//				if dy < 0 {
//					s = stride(from: <#T##Strideable#>, to: <#T##Strideable#>, by: <#T##Comparable & SignedNumeric#>)
//				}
//				for dy in
//			}
			_pointsOccupied.append(contentsOf: points)
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
	case Triangle([Point])//base points, then up
	case Custom([Point])
}
