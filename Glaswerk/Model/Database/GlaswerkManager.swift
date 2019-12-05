//
//  GlaswerkManager.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 15/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import Foundation

class GlaswerkManager {
    let URL = "http://bramlab.ga:4444/"
}

enum BadURLError: Error {
    case runtimeError(String)
}
