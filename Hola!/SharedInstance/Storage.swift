//
//  Storage.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 23.05.2022.
//

import Foundation

class Storage {
    public var my_uid: String = ""
    public var name: String = ""
    public var avatar_id: String = ""
    
    static let sharedInstance = Storage()
}
