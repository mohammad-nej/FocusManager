//
//  EnableFocusModifier.swift
//  FocusManager
//
//  Created by MohammavDev on 3/21/25.
//

import SwiftUI

struct EnableFocusModifier : ViewModifier {
    
    @Environment(\.focusManager) private var manager
    @Environment(\.currentFocusContainer) private var container
    @Environment(\.myFocus) private var myFocusEnv
    
    let isFocuseEnabled : Bool
    
    func body(content: Content) -> some View {
        VStack{
            content
            Text("isFocusEnabled : \(isFocuseEnabled.description)")
        }
        .onAppear {
                
            guard let myFocusEnv else { return }
            guard let manager else { ErrorGenerator(error: .noFocusManagerFoundFor(myFocusEnv));return }
            guard let container else { return}
            
            let myContainer = manager.find(myFocusEnv, in: container)
            guard let myContainer else { return}
            
            myContainer.isFocusable = isFocuseEnabled
            setFocusableForChildren(of: myContainer)
                
        }.environment(\.focuseEnabled, isFocuseEnabled)
    }
    private func setFocusableForChildren(of container : FocusContainer ){
        
        guard container.hasChildren else { return }
        var currentChild : FocusContainer?
        for child in container.children{
            currentChild = child
            currentChild?.isFocusable = isFocuseEnabled
            guard currentChild != nil else { continue }
            currentChild = currentChild!.nextFocus
            while(true){
                guard currentChild?.parent == container else { break }
                currentChild?.isFocusable = isFocuseEnabled
                currentChild = currentChild?.nextFocus
            }
            setFocusableForChildren(of: child)
        }
        
    }

}
