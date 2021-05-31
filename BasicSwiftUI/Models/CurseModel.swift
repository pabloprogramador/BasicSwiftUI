//
//  CurseModel.swift
//  BasicSwiftUI
//
//  Created by Pablo Erick Cardoso on 18/03/2021.
//

import Foundation
struct Course : Identifiable, Decodable {
    let id = UUID()
    let name : String
}
