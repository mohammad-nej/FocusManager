//
//  ContainerManager2.swift
//  FocusManager
//
//  Created by MohammavDev on 3/19/25.
//

import SwiftUI

@Observable
///Use this control focus in your views. This object should be inserted only once in your view hierarchy.
@MainActor public class FocusManager : Identifiable{
    
    
    
    public let id : UUID = UUID()
    
    @MainActor enum Direction : Equatable{
        case forward , backward
    }
    

    @MainActor public enum TraversingStrategy : Equatable{
        case loop , finish
    }
    

    public internal(set) var currentContainer : FocusContainer?
    
    ///currently focused element.
    public var currentFocus : (any FocusableFeilds)?{
        currentContainer?.myFocus
    }
    
    var initial : FocusContainer?

    var lastMove : Direction?
    
    ///Indicate if manager should loop around when reaching top/bottom of the list or not.
    public var strategy : TraversingStrategy = .loop

    ///Initialize and creates a Manager for you
    public init (){
        currentContainer = nil
        initial = nil
        
    }
    internal  init<Focusable:FocusableFeilds>(for model : Focusable.Type){
        let all : [Focusable] = model.allCases.map({$0})
        let linkedList = ContainerBuilder(all.first!).build().first
        
        currentContainer = nil
        initial = linkedList
        
    }
    /// A debug description indicating first 2  nodes in the list.
    public var debugDescription: String {
        return "Manager for : \(initial?.name ?? "nil") , \(initial?.nextFocus?.name ?? "nil") , ..."
    }

    private func moveIn(direction : Direction){
        switch direction {
            case .forward :
            goNext()
        case .backward :
            goPrev()
        }
    }
  
    
    private func hasAtLeastOneFocusableElement() -> Bool{
        // since we always jump over non-focusable elements in the UI, if all elements
        //are non-focusable we will end up being stuck in an infinite loop, this function will prevent that
        //by checking if there is at least one available element to stop at.
        if currentContainer != nil {
            if currentContainer!.isFocusable{
                return true
            }
        }
        var current = initial
        while(true){
            if current == nil{
                return false
            }
            if current!.isFocusable{
                return true
            }
            current = current!.nextFocus
        }
    }
    
    ///Goes to the first focusable element in the UI
    public func goToFirstElement(){
        lastMove = nil
        guard hasAtLeastOneFocusableElement() else { return}
        
        self.currentContainer = _goToFirstElement()
        skipNonFocusableElements(direction: .forward)
    }
    
    private func goToLastElement(in container : FocusContainer?) -> FocusContainer? {
        
        var next : FocusContainer? = nil
        var theOne : FocusContainer? = container
        while(true){
            next = theOne?.nextFocus
            if next == nil{
                return theOne
            }
            theOne = next
        }
        
        
        
    }
    
    ///Goes to the last element in the UI
    public func goToLastElement(){
        lastMove = nil
        guard hasAtLeastOneFocusableElement() else { return}
        let last = goToLastElement(in: initial)
        
        if ((last?.hasChildren) != nil){
            goToNextInitialElement(for: last!)
        }
        skipNonFocusableElements(direction: .backward)
    }
    
    private func _goToLastActualElement(in container : FocusContainer?) -> FocusContainer? {
       
        guard container != nil else { return nil}
        guard container!.hasChildren else { return container}
        var child : FocusContainer? = container!.children.last!
        
        //Going to the last node of the last child
        while(true){
            let next = child?.nextFocus
            if next == nil{
                break
            }
            child = next
        }
        
        //if that last node also has a child , we have to repeat the process recursively
        while(true){
            guard child != nil else { return nil}
            if child!.hasChildren{
               child = _goToLastActualElement(in: child!)
                return child
            }
            return child
        }
    }
    
    ///Goes to the next focusable element in the UI
    public func goNext(){
        lastMove = .forward
        guard hasAtLeastOneFocusableElement() else { return}
//        skipNonFocusableElements(direction: .forward)
        guard currentContainer != nil else {
            goToFirstElement()
            return
        }
        var next = currentContainer?.nextFocus
        
      
        
        if next == nil {
            //if next is nil, we must check if it has any siblings after it or not ?
            while(true){
                if currentContainer?.parent != nil {
                    let parent = currentContainer!.parent
                    guard let parent else {
                        break
                    }
                    if parent.nextFocus == nil {
                        currentContainer = parent
                        continue
                    }
                    currentContainer = parent.nextFocus
                    
                    if currentContainer != nil{
                        //if it does, we should go to next initial element of it's next sibling
                        let first = currentContainer?.children.first
                        if let first{
                            currentContainer = first
                        }

                        goToNextInitialElement(for: currentContainer!)
                        break
                    }
                }else{
                    currentContainer = nil
                    break
                }

            }
        }else{
            //if it's not nil , we just go to the next element
            self.currentContainer = next
            
            //if that element also has a child, we have to go for it's child
            if let currentContainer{
                if currentContainer.hasChildren{
                    goToNextInitialElement(for: currentContainer)
                }
            }
            
        }
        if let currentContainer{
            goToNextInitialElement(for: currentContainer)
        }
//        next = currentContainer
        
        if strategy == .loop {
            //if we have reached to the end of the loop , we should loop from begining
            if currentContainer == nil {
                currentContainer = _goToFirstElement()
           
                skipNonFocusableElements(direction: .forward)
                return
            }
        }
 
        skipNonFocusableElements( direction: .forward)
    }
    internal func goToNextInitialElement(for current : FocusContainer){
        let result = recursiveGoToNextInitialElement(for: current)
        self.currentContainer = result
    }

    private func recursiveGoToNextInitialElement(for current : FocusContainer) -> FocusContainer? {
        let nextOne = current
        while(true){
            let type = type(of: nextOne.myFocus)
            let firstOne = type.initialFocusState
            
            if let firstOne {
                let focusContainer = find(firstOne, in: nextOne)
                guard let focusContainer else {
                    logger.warning("couldn't find focus container for \(firstOne.name)")
                    return nil
                }
                if focusContainer.hasChildren{
                    let nextChild = focusContainer.children.first!
                    let nextOne = recursiveGoToNextInitialElement(for: nextChild)
                    return nextOne
                }else{
                    return focusContainer
                }
            }else{
                guard let next = nextOne.children.first else { return current}
                let nextChild = recursiveGoToNextInitialElement(for: next)
                guard let nextChild else {
                    logger.warning("couldn't find focus container for ")
                    return nil
                }
                if nextChild.hasChildren{
                    let nextChild = nextChild.children.first!
                    let nextOne = recursiveGoToNextInitialElement(for: nextChild)
                    return nextOne
                }else{
                    self.currentContainer = nextChild
                    return nextChild
                }
            }
        }
        return current
    }
    private func findNextFocusableElement(in container: FocusContainer?) -> FocusContainer? {
        guard container != nil else { return nil }
        guard container!.hasChildren else { return container }
        let next = container!.children.first
        while(true){
            guard next != nil else { return container }
            if next!.hasChildren{
                findNextFocusableElement(in: next)
            }
        }
    }

    private func _goToFirstElement() -> FocusContainer?{
        guard let initial else {
            assertionFailure("initial must not be nil")
            return nil }
        
        goToNextInitialElement(for: initial)
        return currentContainer
    }
    
    ///Goes to the previous focusable element in the UI
    public func goPrev(){
        lastMove = .backward
        guard hasAtLeastOneFocusableElement() else { return}
        
        //if it's nil(means nothing is selected at all) , we focus the last element
        guard currentContainer != nil else {
            goToLastElement()
            return
        }
        var prev = currentContainer?.prevFocus
        
        //if prev element is nil , we have to check if does have a parent or not
        if prev == nil {
            
            
            while(true){
                let parent = currentContainer!.parent
                if parent != nil {
                    let parentPrev = parent?.prevFocus
                    currentContainer = parent
                    if parentPrev != nil {
                        break
                    }
                }else{
                    break
                }
                
            }
        }
         
        prev = currentContainer?.prevFocus
        if prev != nil {
            
            currentContainer = _goToLastActualElement(in: prev)
            
        }else{
            if strategy == .loop{
                goToLastElement()
                return
            }else{
                currentContainer = nil
                return
            }
        }
        skipNonFocusableElements(direction: .backward)
    }
    private func skipNonFocusableElements( direction : Direction){
        if currentContainer != nil{
            guard currentContainer!.isFocusable == false else { return}
            while(true){
                moveIn(direction: direction)
                
                if currentContainer == nil  {
                    if strategy == .loop {
                        if direction == .forward{
                            self.currentContainer = _goToFirstElement()
                        }else{
                            self.currentContainer = _goToLastActualElement(in:currentContainer)
                        }
                    }
                }
                guard currentContainer?.isFocusable == false else {
                    return
                }
            }
        }
    }

    
    //only used for testing, add sub focus to an already existing focus
    func insert<Focusable: FocusableFeilds>(_ model : Focusable.Type , under current : (any FocusableFeilds)){
        let feild = model.allCases.map({$0}).first!
        
        let element = find(current,in:initial)
        guard let element else {
            logger.error("related element not found, hash: \(current.name.description)")
            return  }
        
        let builder = ContainerBuilder(feild).build().first!
        
        var current : FocusContainer? = builder
        while(true){
            if current == nil { break}
            current!.parent = element
            current = current!.nextFocus
        }
        
        element.children.insert(builder, at: 0)
        
    }

    ///Detects if any of children views has focus or not?
    func childrendHasFocus(_ parent : FocusContainer) -> Bool{
        for child in parent.children {
            var currentChild : FocusContainer? = child
            while(true){
                guard currentChild != nil else { break}
                if currentContainer == currentChild!{
                    return true
                }
                if currentChild!.hasChildren{
                    let result = childrendHasFocus(currentChild!)
                    if result{
                        return true
                    }
                }
                currentChild = currentChild?.nextFocus
            }
        }
        return false
    }
    
    ///jump to an specefic element in the UI, skipping non-focusable elements.
    public func go(to element : FocusContainer?){
        lastMove = nil
        guard let element else { return}
        guard hasAtLeastOneFocusableElement() else { return}
    
       
        currentContainer = element
    
        goToNextInitialElement(for: element)
        
        skipNonFocusableElements(direction: .forward)
    }
    
    internal func find( _ feild : (any FocusableFeilds), in initial : FocusContainer? ) -> FocusContainer?{
        var next : FocusContainer? = initial
        let myHash = feild.hashValue
        while(next != nil){
            
            if next?.myFocus.hashValue == myHash{
                return next
            }
            if let children = next?.children{
                for child  in children{
                    let result = find(feild,in: child)
                    if result != nil{
                        return result
                    }
                }
            }
            next = next?.nextFocus
            
        }
        return nil
    }
    
    ///Set the focus to nil, removing focus
    public func unFocus(){
        lastMove = nil
        currentContainer = nil
    }
}
extension FocusManager : Equatable {
    nonisolated public static func == (lhs: FocusManager, rhs: FocusManager) -> Bool {
        return lhs.id == rhs.id
    }
}
