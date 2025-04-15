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
 
     @FocusState private var focused : Bool
    public func body(content: Content) -> some View{
        content
            .focused($focused)
            .onChange(of: focused){
                guard focused == false else { return}
                isFocused = false
            }
            .onChange(of: manager?.currentContainer,initial: true){
                guard focusEnabled else {isFocused = false;return}
                guard let myFocus else { isFocused = false;return}
                guard let manager else {isFocused = false;
                    ErrorGenerator(error: .noFocusManagerFoundFor(myFocus));
                    return}
                guard let myContainer = myContainer else {isFocused = false; return}
                if manager.currentContainer == myContainer {
                    isFocused = true;
                    return}
                
                

                isFocused = manager.childrendHasFocus(myContainer)
            }
    }
  
}
