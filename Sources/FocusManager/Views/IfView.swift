//
//  IfView.swift
//  FocusManager
//
//  Created by MohammavDev on 4/1/25.
//

import SwiftUI

public struct If<TrueView : View, FalseView:View,T> : View {
    
    enum Main : FocusableFeilds {
        case  entire
    }
    enum IfState : FocusableFeilds{
        case right , wrong
    }
    
    let condition :  Bool
    let trueView :  TrueView
    let falseView :  FalseView
    let unwrapped : T?
    let hasFalseView : Bool

    public init(_ condition: @autoclosure @escaping () -> Bool , @ViewBuilder if: () -> TrueView , @ViewBuilder else: () -> FalseView) where T == Phantom {
        self.condition = condition()
        self.trueView = `if`()
        self.falseView = `else`()
        hasFalseView = true
        unwrapped = nil
    }
    public init<IfView : View>(`let` : T? , @ViewBuilder _ if: (T) -> IfView , @ViewBuilder else: () -> FalseView ) where TrueView == AnyView{
        unwrapped = `let`
        self.condition = `let` != nil
        if `let` != nil{
            self.trueView = AnyView(`if`(`let`!))
        }else{
            self.trueView = AnyView(EmptyView())
        }
        self.falseView = `else`()
        self.hasFalseView = true
    }
    public init<IFView:View>(`let` : T? , @ViewBuilder _ if: (T) -> IFView) where FalseView == EmptyView , TrueView == AnyView{
        unwrapped = `let`
        self.condition = `let` != nil
        if `let` != nil{
            self.trueView = AnyView(`if`(`let`!))
        }else{
            self.trueView = AnyView(EmptyView())
        }
        self.hasFalseView = true
        self.falseView = EmptyView()
    }
    public var body: some View {
        ZStack{
            if condition {
                
                trueView
                    .focusEnable(condition)
//                    .myFocus(IfState.right)
            }else{
                    falseView
                        .focusEnable(!condition && hasFalseView)
//                        .myFocus(IfState.wrong)

            }
            
        }
        .frame(minWidth:0,minHeight: 0)
        .myFocus(Main.entire)
//        .id(condition)
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
     init(_ condition: @autoclosure @escaping () -> Bool , @ViewBuilder true: () -> TrueView) where T == Phantom {
        self.condition = condition()
        self.trueView = `true`()
       
        self.falseView = EmptyView()
        hasFalseView = false
         self.unwrapped = nil
    }
}
