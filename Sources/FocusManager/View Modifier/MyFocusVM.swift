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

     @State private var isFinishedProccessing : Bool = false
    @State private var newContainer : FocusContainer
    @State private var containerIsResetted : Bool = false
    @State private var isFocsed : Bool = false
    @State private var isActive : Bool = false
    
    @FocusState private var isFocusedState : Bool
    
     init(myFocus : any FocusableFeilds){
         let container = FocusContainer(current: myFocus)
         self.myFocus = myFocus
         self._newContainer = .init(initialValue: container)
     }
     
    let myFocus : any FocusableFeilds
    
    public func body(content: Content) -> some View {

        VStack{
            if isFinishedProccessing{
                content
                    .environment(\.currentFocusContainer, newContainer)
                    .onChange(of: isFocusedState){
                        guard isFocusedState == true else {
                            return
                        }

                        guard newContainer.isFocusable else {
                            isFocusedState = false
                            return}
                        

                        guard let containerManagerEnv else { ErrorGenerator(error: .noFocusManagerFoundFor(myFocus));return}
                        
        //                guard containerManagerEnv.currentContainer == newContainer else { return}
                        
                        let firstChild = newContainer.children.first
                        if let firstChild {
                            
                            
                            containerManagerEnv.goToNextInitialElement(for: firstChild)
                        }else{
                            containerManagerEnv.currentContainer = newContainer
                        }
                    }
            }else{
                Text("")
                    .onAppear{
                        if let currentFocusContainerEnv{
                            addingChild()
                        
                        }else{
                            addingParent()
                        }
                        isFinishedProccessing = true
                    }
                    
            }
        }

  
        .font(.caption)
            .focused($isFocusedState)

            .contentShape(Rectangle())
            .environment(\.myFocus, myFocus)
            .onTapGesture {
                guard let containerManagerEnv else{ ErrorGenerator(error: .noFocusManagerFoundFor(myFocus));return}
                guard isFocusEnabled else { return}
    //            guard let newContainer else { return}
                guard newContainer.hasChildren else {
                    containerManagerEnv.currentContainer = newContainer
                    return
                }
               
                
                containerManagerEnv.goToNextInitialElement(for: newContainer)
                    
                
                
                
            }


            .onChange(of: containerManagerEnv?.currentContainer, initial: true){
                
                guard let containerManagerEnv else { ErrorGenerator(error: .noFocusManagerFoundFor(myFocus));return}
              
//                guard let newContainer else {return}
                guard isFocusEnabled else {

                    return}
                guard let current = containerManagerEnv.currentContainer else {
                    isFocusedState = false
                    return
                }
//                let contHash = current.myFocus.name
                let contHash = current
//                let myHash = myFocus.name
                let myHash = newContainer
//                isFocusedState = current === newContainer
//                if !isFocusedState{
                    if !containerManagerEnv.childrendHasFocus(newContainer){
                        let result = contHash == myHash
                        isFocusedState = result
                    }
//                }
            }

    }
     func addingParent(){
         guard let containerManagerEnv else{  ErrorGenerator(error: .noFocusManagerFoundFor(myFocus)); return}
//                guard containerManagerEnv.find(con)

         let container = FocusContainer(current: myFocus)
 
         newContainer = container
         if let initial = containerManagerEnv.initial{
             
             initial.prevFocus = container
             
             
             newContainer.nextFocus = initial
             self.containerManagerEnv?.initial = newContainer
         }else{
             containerManagerEnv.initial = container
         }
     }
     func addingChild(){
         guard let containerManagerEnv else{  ErrorGenerator(error: .noFocusManagerFoundFor(myFocus)); return}
//                guard containerManagerEnv.find(con)

         let container = FocusContainer(current: myFocus)
 
         newContainer = container
         newContainer.parent = currentFocusContainerEnv
         if let currentFocusContainerEnv{
             let prev = currentFocusContainerEnv.children.first
             if  detectIfItsNewChild(){
                 currentFocusContainerEnv.children.insert(newContainer, at: 0)
//                 if currentFocusContainerEnv.children.count > 1{
//                     let secondOne = currentFocusContainerEnv.children[1]
//                     secondOne.prevFocus = newContainer
//                     newContainer.nextFocus = secondOne
//                 }
                 return
             }
             if let prev {
                 prev.prevFocus = newContainer
                 newContainer.nextFocus = prev
                 currentFocusContainerEnv.children[0] = newContainer
             }else{
                 currentFocusContainerEnv.children.append(newContainer)
             }
         }
     }
     private func detectIfItsNewChild() -> Bool{
         guard let prev = currentFocusContainerEnv?.children.first else { return true}
         let prevFocus = prev.myFocus
         let typeOfPrev = type(of: prevFocus)
         let currentType = type(of: myFocus)
         
         if currentType != typeOfPrev{
             return true
         }
         
         let lastElement = typeOfPrev.allCases.map{ $0 as! any FocusableFeilds }.first!
         if prevFocus.hashValue == lastElement.hashValue{
             return true
         }
         return false
     }
}
