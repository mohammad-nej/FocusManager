//
//  FocusContainer.swift
//  FocusManager
//
//  Created by MohammavDev on 3/17/25.
//

import Foundation

public final class FocusContainer :  Equatable, Identifiable , Hashable {

    let uuid : UUID = UUID()

    public var isFocusable : Bool = true
    
    public var parent : FocusContainer?
    public var children : [FocusContainer] = []
 
    public var name : String{
        myFocus.name
    }
    
    public var hasChildren : Bool {
        return !children.isEmpty
    }

    public static func == (lhs: FocusContainer, rhs: FocusContainer) -> Bool {
         return lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
     init(current: (any FocusableFeilds)){
        self.myFocus = current
      
    }
//    func create() -> Self {
//        let prevFocus = myFocus.prevElement
//       
//        let nextFocus = myFocus.nextElement
//        
//        if let prevFocus{
//            self.prevFocus = .init(current: prevFocus)
//            self.prevFocus?.nextFocus = self
//        }
//        
//        if let nextFocus{
//            self.nextFocus = .init(current: nextFocus)
//            self.nextFocus?.prevFocus = self
//        }
//        return self
//    }
    public internal(set) var prevFocus : ( FocusContainer)?
    public internal(set) var myFocus : any FocusableFeilds
    public internal(set) var nextFocus : ( FocusContainer)?
}
extension FocusContainer : CustomDebugStringConvertible {
    public var debugDescription: String {
        return "prev:\(prevFocus?.myFocus.name.description ?? "nil") , my : \(myFocus.name.description), next : \(nextFocus?.myFocus.name.description ?? "nil")"
    }
}


