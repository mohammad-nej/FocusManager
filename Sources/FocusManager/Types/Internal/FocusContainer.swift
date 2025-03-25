//
//  FocusContainer.swift
//  FocusManager
//
//  Created by MohammavDev on 3/17/25.
//



@MainActor  final class FocusContainer : @preconcurrency Equatable  {


    var isFocusable : Bool = true
    
    var parent : FocusContainer?
    var children : [FocusContainer] = []
    
    var myHash : Int {
        return myFocus.myHash
    }
    
    var hasChildren : Bool {
        return !children.isEmpty
    }

     static func == (lhs: FocusContainer, rhs: FocusContainer) -> Bool {
        return lhs.myFocus.myHash == rhs.myFocus.myHash
    }
     init(current: (any FocusableFeilds)){
        self.myFocus = current
      
    }
    func create() -> Self {
        let prevFocus = myFocus.prevElement
       
        let nextFocus = myFocus.nextElement
        
        if let prevFocus{
            self.prevFocus = .init(current: prevFocus)
            self.prevFocus?.nextFocus = self
        }
        
        if let nextFocus{
            self.nextFocus = .init(current: nextFocus)
            self.nextFocus?.prevFocus = self
        }
        return self
    }
    public internal(set) var prevFocus : ( FocusContainer)?
    public internal(set) var myFocus : any FocusableFeilds
    public internal(set) var nextFocus : ( FocusContainer)?
}
extension FocusContainer : @preconcurrency CustomDebugStringConvertible {
    public var debugDescription: String {
        return "prev:\(prevFocus?.myFocus.myHash.description ?? "nil") , my : \(myFocus.myHash.description), next : \(nextFocus?.myFocus.myHash.description ?? "nil")"
    }
}


