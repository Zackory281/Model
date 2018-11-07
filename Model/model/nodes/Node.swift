//
//  Node.swift
//  Model
//
//  Created by Zackory Cramer on 10/26/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

protocol Node {
	
	func getPoint() -> Point
	func getOrientations() -> [Direction]
	func getType() -> NodeType
	func getX() -> IntC
	func getY() -> IntC
	func getColorCode() -> NSColor
}
