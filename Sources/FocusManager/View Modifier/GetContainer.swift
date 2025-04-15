//
//  GetContainer.swift
//  FocusManager
//
//  Created by MohammavDev on 3/31/25.
//

import SwiftUI


public struct GetContainer : ViewModifier {
    
    @Environment(\.currentFocusContainer) private var currentFocusContainer
    let binding : Binding<FocusContainer?>
    
    
    
    public func body(content: Content) -> some View {
        
        content
            .onChange(of: currentFocusContainer,initial: true){
                binding.wrappedValue = currentFocusContainer
            }
    }
    
    
}
