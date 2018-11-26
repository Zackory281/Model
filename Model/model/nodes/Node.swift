//
//  Node.swift
//  Model
//
//  Created by Zackory Cramer on 10/26/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

class NodeAbstract: NSObject {
	var _point: Point = (0, 0)
	var _type: NodeType { get { return .Shape} }
	var _color: NSColor? { get { return nil} }
	var _category: INTB { get { return NODE_TO_CATEGORY[_type]! } }
	var _overlap: INTB { get { return NODE_TO_COLLISION[_type]! } }
	lazy var _hash: Int = {return getHash()}()
	override var hash: Int {get{ return _hash}}
}
