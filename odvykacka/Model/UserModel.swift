//
//  UserModel.swift
//  odvykacka
//
//  Created by Filip Adámek on 29.05.2023.
//

import Foundation
import SwiftUI

struct UserModel: Identifiable{
    let id: UUID
    var nickname: String
    var addiction: String
    var profilePicture: UIImage
    var motivationPicture: UIImage
    
}
