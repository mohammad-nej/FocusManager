//
//  GetFocusManager.swift
//  FocusManager
//
//  Created by MohammavDev on 4/12/25.
//

import SwiftUI


 struct GetFocusManager : ViewModifier {
    
    @Environment(\.focusManager) private var manager
    let binding : Binding<FocusManager?>
    
    
    
    public func body(content: Content) -> some View {
        
        content
            .onChange(of: manager,initial: true){
                binding.wrappedValue = manager
            }
    }
    
    
}
