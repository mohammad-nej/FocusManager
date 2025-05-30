//
//  FocusableFeilds.swift
//  FocusManager
//
//  Created by MohammavDev on 3/16/25.
//


import SwiftUI
import Foundation



///Main protocol to use in this package. In order to create focusable elements, simply create and enum and conform to this protocol
///
///```swift
///     enum BirthDay : FocusableFeilds{
///         case day , month , year
///     }
///```
///now you can assign these fields to your views using `myFocus(_ myFocus : any FocusableFeilds)` modifier.
///```swift
///     VStack{
///          TextField("Day",text:$day)
///             .myFocus(BirthDay.day)
///            // .
///            // .
///            // .
///         }
///```
/// - Note: FocusManager object will  traverse the elements <b>in order</b>, which means that order of your enums cases matters.
///

 public protocol FocusableFeilds:Sendable,   Hashable , Equatable, CaseIterable {
    
    ///By setting this to any other value than nil, focusManager will automatically jumps to your selected child
    ///
    ///```swift
    ///     VStack{
    ///             TextField("Year",text:$year)
    ///                 .myFocus(BirthDay.year)
    ///             TextField("Month",text:$year)
    ///                 .myFocus(BirthDay.month)
    ///     }.myFocus(Fields.birthday)
    ///```
    ///by setting `initialFocusState` of `BirthDay` enum to `month`, focusManager will automatically jumps to `month` when
    ///`Field.birthday` is focused.
    ///```swift
    ///     enum BirthDay:FocusableFeilds{
    ///         case day , month,year
    ///          static var initialFocusState : Self? { .month }
    ///     }
    ///```
    /// - Warning: In order for this variable to work, it has to be visibile inside the scope of ``FocusManager`` thus it's awalys better
    /// to define it as either
     static var initialFocusState : Self? { get }

}
public extension FocusableFeilds {
 
    ///a name created using String(describing) function, used for debugging
    var name : String {
        String(describing: self)
    }
    
//    ///a unique hash created for each field
//    var myHash : Int {
//        
//        let type = type(of: self)
//        let description = String(describing: type)
//
//        var hasher = Hasher()
//        hasher.combine(self)
//        hasher.combine(description)
//        return hasher.finalize()
//    }
    
 
    static var initialFocusState : Self? {
        return nil
    }
    }
 extension FocusableFeilds {
    var lastElement : Self? {
        return Self.allCases.map(\.self).last
    }
    var nextElement : Self? {
        
        
        let allCases = Self.allCases.map(\.self)
        let index = allCases.firstIndex(of: self)
        
        guard let index else {
            logger.error("current element not found in the allCases list, returning nil instead")
            return nil
        }
        let next = (index + 1 ) < allCases.count ? (index + 1 ) : nil
        
        guard let next else { return nil}
        return allCases[next]
    }
    var prevElement : Self? {
        let allCases = Self.allCases.map(\.self)
        let index = allCases.firstIndex(of: self)
        
        guard let index else {
            logger.error("current element not found in the allCases list, returning nil instead")
            return nil
        }
        let prev = (index - 1 ) >= 0 ? (index - 1 ) : nil
        
        guard let prev else { return nil}
        return allCases[prev]
    }


}
