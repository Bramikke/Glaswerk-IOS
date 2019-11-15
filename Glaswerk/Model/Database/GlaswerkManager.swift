//
//  GlaswerkManager.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 15/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import Foundation

class GlaswerkManager {
    let URL = "http://ec2-35-180-181-246.eu-west-3.compute.amazonaws.com:8080/"
    //let URL = "http://192.168.0.125:8080/"
}

enum BadURLError: Error {
    case runtimeError(String)
}
