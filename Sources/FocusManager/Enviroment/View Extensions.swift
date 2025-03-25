//
//  View Extensions.swift
//  FocusManager
//
//  Created by MohammavDev on 3/22/25.
//


import SwiftUI

public extension View {

    ///Main modifier used to assign a FocusableFeild to your UI elements.
    ///```swift
    ///struct ExampleView : View {
    ///
    /// enum Fields : FocusableFeilds {
    ///     case name , family , birthDay , age
    /// }
    ///
    /// enum BirthDay : FocusableFeilds {
    ///     case day , month , year
    /// }
    ///
    ///
    /// @State private var name : String = ""
    /// @State private var family : String = ""
    ///
    /// @State private var day : String = ""
    /// @State private var month : String = ""
    /// @State private var year : String = ""
    ///
    /// @State private var age : String = ""
    ///
    /// let manager = FocusManager(for: Fields.self)
    /// var body : some View {
    ///    VStack{
    ///
    ///        Button("Go Next"){
    ///           manager.goNext()
    ///       }
    ///
    ///      TextField("Name", text: $name)
    ///         .myFocus(Fields.name)
    ///     TextField("Family", text: $family)
    ///         .myFocus(Fields.family)
    ///
    ///     HStack{
    ///         TextField("Day", text: $day)
    ///             .myFocus(BirthDay.day)
    ///         TextField("Month", text: $month)
    ///             .myFocus(BirthDay.month)
    ///
    ///         TextField("Year", text: $year)
    ///             .myFocus(BirthDay.year)
    ///     }.myFocus(Fields.birthDay)
    ///
    ///     TextField("Age", text: $age)
    ///         .myFocus(Fields.age)
    ///
    /// }.focusManager(manager)
    /// }
    ///
    ///
    ///}
    ///```
    func myFocus(_ myFocus : any FocusableFeilds) -> some View {
            modifier(MyFocusVM2(myFocus: myFocus))
    }
    
    ///By setting this to false , you can prevent an element from being focused.
    /// - Note: In order for this modifier to work correctly it has to be applied `before` myFocus modifier
    /// ```swift
    /// TextField("Day",text:$day)
    ///     .focusEnable(false)
    ///     .myFocus(BirthDay.day)
    ///```
    ///
    func focusEnable(_ enable : Bool) -> some View {
        modifier(EnableFocusModifier(isFocuseEnabled: enable))
    }
    
    ///Lets you now if this element ( or any of it's children) has the focus or not.
    /// - Note: `binding` should only be used to read values, wirting to `binding` variable has no effect.
    func isActive(_ binding : Binding<Bool>) -> some View {
      
        modifier(isActiveModifier(isFocused: binding))
    }
    
    ///Creates a FocusManager for your view herirarchy. Only one focusManager should exits in each view herirarchy.
    ///
    ///You can access this object in your subviews using SwiftUIs environment
    ///```swift
    ///struct SubView : View {
    /// @Environment(\.focusManager) private var manager
    ///         //.....
    /// }
    /// ```
    ///
    /// - Warning: Don't attempt to insert `FocusManager` directly using environment(\\.focusManager,manager) modifier. Always use
    /// this modifier instead cause it will prevent you from inserting a FocusManager if it already exits.
    func focusManager(_ manager : FocusManager) -> some View {
        modifier(FocusManagerModifier(manager: manager))
    }
}
