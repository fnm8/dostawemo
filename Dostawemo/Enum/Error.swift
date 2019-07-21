//
//  Error.swift
//  Dostawemo
//
//  Created by fnm8 on 18/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import Foundation


enum LError: Error {
    case serialize(_ message: String)
    case db(_ message: String)
    case app(_ message: String)
}
