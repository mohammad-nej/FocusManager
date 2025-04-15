//
//  OnActivation.swift
//  FocusManager
//
//  Created by MohammavDev on 4/3/25.
//

import SwiftUI

struct OnActivationModifier : ViewModifier {
    
    let action : () -> Void
    let initialTrigger : Bool
    @State private var isActivated : Bool = false
    
    
    func body(content: Content) -> some View {
        content
            .isActive($isActivated)
            .onChange(of: isActivated , initial: initialTrigger){
                guard isActivated else { return }
                action()
            }
    }
    
}
