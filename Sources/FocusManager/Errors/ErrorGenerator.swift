//
//  FocusStateTransitionError.swift
//  FocusManager
//
//  Created by MohammavDev on 3/16/25.
//


import SwiftUI
import Foundation


 @MainActor enum ErrorMessages {
     case noFocusManagerFoundFor(any FocusableFeilds) , focusManagerAlreadyExist(FocusManager,FocusManager), feildNotFoundIn(any FocusableFeilds , FocusContainer)

     var description: String {
        switch self {
        case .noFocusManagerFoundFor(let feild):
            return "No FocusManager found in the environment for \(feild.name). seems like you forget to add .focusManager() modifier to your parent view."
        case .focusManagerAlreadyExist(let old, let new):
            return "Focus Manager already exitst (\(old.debugDescription)) in the view heirarchy, attempting to resseting it has no effect, this insertion(\(new.debugDescription)) will be ignored.\n You can capture current manager using @Environment(\\.focusManager) in your view."
        case .feildNotFoundIn(let feild, let container):
            return "Element \(feild.name) not found in container : \(container.debugDescription)"
        }
    }
}

@MainActor struct ErrorGenerator{
    
    @discardableResult
    init(error: ErrorMessages){
        logger.error("Error: \(error.description)")
    }
}
