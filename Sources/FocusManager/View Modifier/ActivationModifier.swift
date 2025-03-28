////
////  ActivationModifier.swift
////  FocusManager
////
////  Created by MohammavDev on 3/19/25.
////
//
import SwiftUI

 struct isActiveModifier: ViewModifier {
    @Environment(\.myFocus) private var myFocus
    @Environment(\.currentFocusContainer) private var myContainer
    @Environment(\.focusManager) private var manager
    @Environment(\.focuseEnabled) private var focusEnabled

    
    @Binding var isFocused : Bool
 
    public func body(content: Content) -> some View{
        content
            .onChange(of: manager?.currentContainer?.myFocus.myHash,initial: true){
                guard focusEnabled else {isFocused = false;return}
                guard let myFocus else { isFocused = false;return}
                guard let manager else {isFocused = false;ErrorGenerator(error: .noFocusManagerFoundFor(myFocus));return}
                
                if manager.currentContainer?.myFocus.myHash == myFocus.myHash {isFocused = true;return}
                
                guard let myContainer else {isFocused = false; return}

                isFocused = manager.childrendHasFocus(myContainer)
            }
    }
  
}
