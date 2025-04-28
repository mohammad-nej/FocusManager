//
//  FocusManagerModifier.swift
//  FocusManager
//
//  Created by MohammavDev on 3/22/25.
//

import SwiftUI

struct FocusManagerModifier : ViewModifier{
//    @Environment(\.focusManager) private var managerEnv
    let manager: FocusManager
    
    func body(content: Content) -> some View {
        content
//            .onAppear {
//                if managerEnv != nil {
//                    ErrorGenerator(error:.focusManagerAlreadyExist(managerEnv!, manager))
//                    return
//                }
//                
//            }
            .environment(\.focusManager, manager)//managerEnv == nil ? manager : managerEnv!)
    }
}
