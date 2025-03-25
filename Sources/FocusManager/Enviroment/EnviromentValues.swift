//
//  EnviromentValues.swift
//  FocusManager
//
//  Created by MohammavDev on 3/16/25.
//
import SwiftUI


public extension  EnvironmentValues  {
    ///Contains main focusManager for you view.
    ///
    /// - Warning: don't attempt to set this value using .environment(), always use .focusManager() viewModifier instead.
    @Entry var focusManager : FocusManager? = nil
}
 extension EnvironmentValues {
    @Entry var currentFocusContainer : FocusContainer? = nil
    @Entry var focuseEnabled: Bool = true
    @Entry var myFocus : (any FocusableFeilds)? = nil
}


