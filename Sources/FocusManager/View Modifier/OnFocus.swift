//
//  OnFocus.swift
//  FocusManager
//
//  Created by MohammavDev on 4/1/25.
//

import SwiftUI


struct OnFocusModifier : ViewModifier {
    @Environment(\.focusManager) private var manager
    @Environment(\.currentFocusContainer) private var container
    @Environment(\.focuseEnabled) private var isFocusEnabled
    
    @State private var isActive : Bool = false
    
    let action : (FocusContainer?,FocusManager?) -> Void
    
    func body(content: Content) -> some View {
        content
            .isActive($isActive)
            .onChange(of: isActive,initial: true){
                guard  isActive else { return }
                action(container,manager)
            }
    }
    
  
}
