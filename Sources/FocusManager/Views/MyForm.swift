//
//  MyForm.swift
//  FocusManager
//
//  Created by MohammavDev on 4/12/25.
//

import SwiftUI

public struct MyForm<Content : View> : View {
    
    let content : Content
    let spacing : CGFloat
    
    public init(spacing : CGFloat = 16 , @ViewBuilder content : () -> Content){
        self.spacing = spacing
        self.content = content()
    }
    @State private var manager : FocusManager = .init()
    public var body: some View {
        MyVStack(spacing: spacing){
            content
        }.focusManager(manager)
    }
}
