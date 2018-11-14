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
	override var _type: NodeType { get { return .Geometry } }
	override var _category: UInt { get { return 0b0010}}
	override var _overlap: UInt { get { return 0b0011}}
	init(anchor: Point, geometry: GeometryType) {
		_pointsOccupied = []
		_geometry = geometry
		super.init()
		_point = anchor
		switch geometry {
		case let .Square(width, height):
			for x in 0..<width {
				for y in 0..<height {
					_pointsOccupied.append((anchor.0 + x, anchor.1 + y))
				}
			}
		default:
			break
		}
	}
}

enum GeometryType {
	case Square(width: IntC, height: IntC)
}
