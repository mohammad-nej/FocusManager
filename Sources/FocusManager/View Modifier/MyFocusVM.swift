//
//  MyFocusVM2.swift
//  FocusManager
//
//  Created by MohammavDev on 3/17/25.
//

import SwiftUI


 struct MyFocusVM2 : ViewModifier {
    
    @Environment(\.focusManager) var containerManagerEnv
    @Environment(\.currentFocusContainer) var currentFocusContainerEnv
    @Environment(\.myFocus) var myFocusEnv
    @Environment(\.focuseEnabled) var isFocusEnabled

    @State private var newContainer : FocusContainer?
    @State private var containerIsResetted : Bool = false
    @State private var isFocsed : Bool = false
    @State private var isActive : Bool = false
    
    @FocusState private var isFocusedState : Bool
    
    let myFocus : any FocusableFeilds
    public func body(content: Content) -> some View {

        VStack{
            content


        }

        .onTapGesture {
            guard let containerManagerEnv else{ ErrorGenerator(error: .noFocusManagerFoundFor(myFocus));return}

            guard let newContainer else { return}
            guard newContainer.hasChildren else { return}
            guard isFocusEnabled else { return}
          
            containerManagerEnv.goToNextInitialElement(for: newContainer)
                
            
            
            
        }
        .font(.caption)
            .focused($isFocusedState)
            .onAppear{
                guard let containerManagerEnv else{  ErrorGenerator(error: .noFocusManagerFoundFor(myFocus)); return}
                defer{
                    let currnet = containerManagerEnv.find(myFocus, in: containerManagerEnv.initial)
                    
                    newContainer = currnet
                }
                guard let myFocusEnv else { return}
                
                //if element is nil, it means that we are inserting a new one into the feild
                let type = type(of: myFocus)
                containerManagerEnv.insert(type, under: myFocusEnv)
    
            }
            
            .environment(\.myFocus, myFocus)

            .if(newContainer != nil){ view in
                view
                    .environment(\.currentFocusContainer, newContainer)
            }

            .onChange(of: isFocusedState){
                guard isFocusedState == true else {
                    return
                }
                guard let newContainer else { return}
                let focusEnabled = containerManagerEnv?.find(myFocus, in: newContainer)?.isFocusable
                guard let focusEnabled else {
                    ErrorGenerator(error: .feildNotFoundIn(myFocus, newContainer))
                    return
                }
                guard focusEnabled else {
                    isFocusedState = false
                    return}
                guard let containerManagerEnv else { ErrorGenerator(error: .noFocusManagerFoundFor(myFocus));return}
                
              
                guard !newContainer.hasChildren else{ return}
                
                containerManagerEnv.go(to: myFocus)
            }
            .onChange(of: containerManagerEnv?.currentContainer?.myFocus.myHash){
                
                guard let containerManagerEnv else { ErrorGenerator(error: .noFocusManagerFoundFor(myFocus));return}
              
                guard let newContainer else { return}
                guard isFocusEnabled else {

                    return}
                guard let current = containerManagerEnv.currentContainer else {
                    isFocusedState = false
                    return
                }
                let contHash = current.myFocus.myHash
                let myHash = myFocus.myHash
                
                if !containerManagerEnv.childrendHasFocus(newContainer){
                    let result = contHash == myHash
                    isFocusedState = result
                }

            }

    }
}
