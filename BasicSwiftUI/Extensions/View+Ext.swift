//
//  View+Ext.swift
//  BasicSwiftUI
//
//  Created by Pablo Erick Cardoso on 29/03/2021.
//

import Foundation
import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
