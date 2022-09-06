//
//  Errors.swift
//  TestTask
//
//  Created by Константин Каменчуков on 06.09.2022.
//

import Foundation

enum MobileStorageErrors: Error {
    case noImei
    case noModel
    case notInMemory
    case notUniqueImei
 
}
