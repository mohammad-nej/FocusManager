//
//  ifMod.swift
//  FocusManager
//
//  Created by MohammavDev on 3/18/25.
//

import SwiftUI
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
