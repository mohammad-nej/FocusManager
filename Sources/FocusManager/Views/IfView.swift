//
//  IfView.swift
//  FocusManager
//
//  Created by MohammavDev on 4/1/25.
//

import SwiftUI

public struct If<TrueView : View, FalseView:View> : View {
    
    enum Main : FocusableFeilds {
        case  entire
    }
    enum IfState : FocusableFeilds{
        case right , wrong
    }
    
    let condition :  Bool
    let trueView :  TrueView
    let falseView :  FalseView
    
    let hasFalseView : Bool

    public init(_ condition: @autoclosure @escaping () -> Bool , @ViewBuilder if: () -> TrueView , @ViewBuilder else: () -> FalseView) {
        self.condition = condition()
        self.trueView = `if`()
        self.falseView = `else`()
        hasFalseView = true
    }
 
    public var body: some View {
        ZStack{
            if condition {
                
                trueView
                    .focusEnable(condition)
                    .myFocus(IfState.right)
            }else{
                    falseView
                        .focusEnable(!condition && hasFalseView)
                        .myFocus(IfState.wrong)

            }
            
        }
        .frame(minWidth:0,minHeight: 0)
        .myFocus(Main.entire)
    }
    var isEntireFocusable : Bool {
        if hasFalseView {
            return true
        }else{
            return condition
        }
    }
}
//}

public extension If where FalseView == EmptyView {
     init(_ condition: @autoclosure @escaping () -> Bool , @ViewBuilder true: () -> TrueView) {
        self.condition = condition()
        self.trueView = `true`()
       
        self.falseView = EmptyView()
        hasFalseView = false
    }
}
