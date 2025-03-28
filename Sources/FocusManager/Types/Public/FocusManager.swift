//
//  ContainerManager2.swift
//  FocusManager
//
//  Created by MohammavDev on 3/19/25.
//

import SwiftUI

@Observable
///Use this control focus in your views. This object should be inserted only once in your view hierarchy.
@MainActor public class FocusManager{
    
    @MainActor enum Direction : Equatable{
        case forward , backward
    }
    

    @MainActor public enum TraversingStrategy : Equatable{
        case loop , finish
    }
    

    var currentContainer : FocusContainer?
    
    ///currently focused element.
    public var currentFocus : (any FocusableFeilds)?{
        currentContainer?.myFocus
    }
    
    var initial : FocusContainer?
    var allCases : [any FocusableFeilds]
    
    ///Indicate if manager should loop around when reaching top/bottom of the list or not.
    public var strategy : TraversingStrategy = .loop

    ///Initialize and creates a Manager for you based the given type
    public  init<Focusable:FocusableFeilds>(for model : Focusable.Type){
        let all : [Focusable] = model.allCases.map({$0})
        let linkedList = ContainerBuilder(all.first!).build().first
        currentContainer = nil
        initial = linkedList
        allCases = all
        
    }
    /// A debug description indicating first 2  nodes in the list.
    public var debugDescription: String {
        return "Manager for : \(initial?.myFocus.name ?? "nil") , \(initial?.nextFocus?.myFocus.name ?? "nil") , ..."
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
        guard hasAtLeastOneFocusableElement() else { return}
        let last = goToLastElement(in: initial)
        self.currentContainer = last
        skipNonFocusableElements(direction: .backward)
    }
    
    private func _goToLastActualElement(in container : FocusContainer?) -> FocusContainer? {
        //because of how swiftUI modifiers work, when we are creating the link list ,
        //there are some inconsistencies  with creating focus.prevFocus in focusContainers,
        //this function will ensure that when we are moving to a previous element, we are actually moving to a leaf node
        /// ```swift
        ///     VStack{
        ///         TextFeild(...)
        ///             .myFocus(something)
        ///          TextFeild(..)
        ///             .myFocus(other)
        ///       }
        ///     .myFocus(parent)
        ///     VStack{
        ///         Text(...)
        ///         .myFocus(another)
        ///     }.myFocus(parent2)
        ///
        ///in this case SwiftUI calls the modifiers from bottom to up, thus when creating link list for `parent` since `something` and `other` are not called yet they don't exists
        ///thus it doesn't take them into account when setting `another.prevFocus` , thus when going backward we have to check if the prev node has any child(recursively),
        ///and if it does so , we should go to the last element of it's children. in this case `another.prevFocus` should be `other`.
        ///this problem doesn't happen for container.nextFocus because when calling from bottom to up the next element is already created xD !
        guard container != nil else { return nil}
        guard container!.hasChildren else { return container}
        var child : FocusContainer? = container!.children.last!
        while(true){
            guard child != nil else { return nil}
            if child!.hasChildren{
               child = _goToLastActualElement(in: child!)
                return child
            }else{
                let currentParent = child?.parent
                while(true){
                    let next = child?.nextFocus
                    guard let next else { return child}
                    if next.parent != currentParent{
                        return child
                    }
                    child = next
                }
            }
        }
    }
    
    ///Goes to the next focusable element in the UI
    public func goNext(){
        guard hasAtLeastOneFocusableElement() else { return}
        guard currentContainer != nil else {
            goToFirstElement()
            return
        }
        let next = currentContainer?.nextFocus
        
        if strategy == .loop {
            if next == nil {
                currentContainer = _goToFirstElement()
           
                skipNonFocusableElements(direction: .forward)
                return
            }
        }
        self.currentContainer = next
        while(true){
            
            let firstChild = currentContainer?.children.first
            
            
            //if a parent node , has more than 1 child, since we have already
            //chained them together, we have to check when we are moving from one child to another,
            // if we are doing so we should jump to their related initialElement when changing focus
            let children = currentContainer?.parent?.children ?? []
            for child in children where child != firstChild {
                if (currentContainer?.myHash == child.myHash){
                    goToNextInitialElement(for: child)
                    break
                }
            }
            
            guard let firstChild else {
                break
            }
            goToNextInitialElement(for: firstChild)
            
         
            
            
            if !firstChild.hasChildren{
                break
            }
            
        }
        skipNonFocusableElements( direction: .forward)
    }
    internal func goToNextInitialElement(for current : FocusContainer){
        let result = recursiveGoToNextInitialElement(for: current)
        self.currentContainer = result
    }
    
    private func goToLastElement(of parent : FocusContainer , in container : FocusContainer) -> FocusContainer{
        var current : FocusContainer = container
        guard current.nextFocus != nil else { return current}
        var next = current.nextFocus
        
        while(true){
            if next == nil || next?.parent != parent{
                return current
            }
            current = next!
            next = current.nextFocus
        }
        
    }
    private func recursiveGoToNextInitialElement(for current : FocusContainer) -> FocusContainer? {
        let nextOne = current
        while(true){
            let type = type(of: nextOne.myFocus)
            let firstOne = type.initialFocusState
            
            if let firstOne {
                let focusContainer = find(firstOne, in: nextOne)
                guard let focusContainer else {
                    logger.warning("couldn't find focus container for \(firstOne.myHash)")
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
        //Algorithm :
        ///1 - we check is there is any focusable element in the field
        /// 1-1 : if does we continue
        ///  1-2 : else we just exit
        ///2: we check if current container is nil (nothing is selected already)
        /// 2-1: we go to last element (skipping non focusable ones)
        ///3: we check if prev element of this element is nil
        ///    if it's nil, it might either be the last element in the entire tree, or just the element
        ///    of a first child in a tree.
        ///  3-1: if has a parent, which means that it's the first element in children of a sub tree
        ///  we go to it's parent node
        ///     if parent node does have a prev node, we go to the parent's prev node
        ///     if not, we keep going up and repeating the process
        ///     if we reach nil (aka top level) we just go the previous node in the top level tree
        ///     if that node doesn't have any prev node, we must go to the last element in the top tree
        ///4: if the prev node is not nil , we just go to prev node ( skipping non-focusable ones)
        
        
        guard hasAtLeastOneFocusableElement() else { return}
        guard currentContainer != nil else {
            goToLastElement()
            return
        }
        var prev = currentContainer?.prevFocus
        
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
            currentContainer = prev
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

    func insert<Focusable: FocusableFeilds>(_ model : Focusable.Type , under current : (any FocusableFeilds)) {
        
        let feild = model.allCases.map({$0}).first!
        
        let element = find(current,in:initial)
        guard let element else {
            logger.error("related element not found, hash: \(current.myHash.description)")
            return }
        let newIndex = find(feild, in:initial)
        //if the newIndex is not nill , it means that we have already inserted this element, we just return
        guard newIndex == nil else { return  }
        
        
        
        let newContainer = ContainerBuilder(feild).build().first
        guard let newContainer else { return }
        set(parent: element, in: newContainer)
        
        
        let firstChild = element.children.first
        
        element.children.insert( newContainer, at: 0)
        if let firstChild{
            element.nextFocus = newContainer
//            element.nextFocus = newContainer
            newContainer.prevFocus = nil
            
            let lastElementInNewContainer = goToLastElement(of: element, in: newContainer)
            firstChild.prevFocus = lastElementInNewContainer
            lastElementInNewContainer.nextFocus = firstChild
            
//            let lastElementInLastChild = goToLastElement(of: element, in: lastChild)
//            
//            lastElementInLastChild.nextFocus = newContainer
//            newContainer.prevFocus = lastElementInLastChild
        }else{
            newContainer.prevFocus =  nil
            setNextFocus(of: newContainer, to: element.nextFocus)
        }
        
        
        //setting to start again
//        self.currentContainer = initial
    }
    private func setNextFocus(of newContainer : FocusContainer , to element : FocusContainer?){
        //if there is no next , traversing the link list is just unneccessary
        guard let element else { return  }
        var current : FocusContainer? = newContainer
        while(true){
            if current?.nextFocus == nil {
                current?.nextFocus = element
                element.prevFocus = current
                break
            }
            current = current?.nextFocus
        }
        
    }
    private func set(parent element : FocusContainer, in list : FocusContainer){
        var current : FocusContainer? = list
        while(current != nil){
            current?.parent = element
            current = current?.nextFocus
        }
    }
    
    ///Detects if any of children views has focus or not?
    public func childrenHasFocus(_ parent : any FocusableFeilds) -> Bool{
        let parent = find(parent, in: initial)
        guard let parent else { return false }
        return childrendHasFocus(parent)
    }
    internal func childrendHasFocus(_ parent : FocusContainer) -> Bool{
        
        
        
        for child in parent.children {
            var currentChild : FocusContainer? = child
            while(true){
                guard currentChild != nil else { break}
                if currentContainer?.myFocus.myHash == currentChild!.myFocus.myHash{
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
    public func go(to element : any FocusableFeilds){
        guard hasAtLeastOneFocusableElement() else { return}
        let find = self.find(element, in: initial)
        
        guard let find else {
            logger.error("Can't find \(element.myHash) in the list")
            return}
       
        currentContainer = find
        if find.hasChildren{
            goToNextInitialElement(for: find)
        }
        skipNonFocusableElements(direction: .forward)
    }
    internal func find( _ feild : (any FocusableFeilds), in initial : FocusContainer? ) -> FocusContainer?{
        var next : FocusContainer? = initial
        let myHash = feild.myHash
        while(next != nil){
            
            if next?.myFocus.myHash == myHash{
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
        currentContainer = nil
    }
}
