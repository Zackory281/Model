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
	
	func getFloatVector() -> float2
	func getPoint() -> [Int16]
	func getOrientations() -> [Direction]
	
}
