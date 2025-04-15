//
//  IfView.swift
//  FocusManager
//
//  Created by MohammavDev on 4/1/25.
//

import SwiftUI

public struct If<TrueView : View, FalseView:View> : View {
    
    @Environment(\.currentFocusContainer) private var currentFocusContainer
    
    @Namespace private var namespace
    
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
    
    @State private var mainContainer : FocusContainer? = nil
    @State private var trueContainer : FocusContainer? = nil
    @State private var falseContrainer : FocusContainer? = nil
    
    public init(_ condition: @autoclosure @escaping () -> Bool , @ViewBuilder if: () -> TrueView , @ViewBuilder else: () -> FalseView) {
        self.condition = condition()
        self.trueView = `if`()
        self.falseView = `else`()
        hasFalseView = true
    }
    var actualMainContainer : FocusContainer? {
        self.mainContainer?.nextFocus
    }

    public var body: some View {
        ZStack{
            if condition {
                
                trueView
//                    .onLoseFocus{ container , manager in
//                        guard let manager else { return}
//                        //                        guard condition == false else { return}
//                        guard let lastmove = manager.lastMove else {
//                            manager.currentContainer = actualMainContainer
//                            manager.goNext()
//                            return
//                        }
//                       
//                        if lastmove == .backward{
//                            manager.currentContainer = falseContrainer
//                            manager.goPrev()
//                            //                            manager.goNext()
//                        }
////                        else{
////                            manager.currentContainer = actualMainContainer?.prevFocus
////                            manager.goPrev()
////                        }
//         
//                    }
                    .focusEnable(condition)
                    .getContainer($trueContainer)
                    .myFocus(IfState.right)
            }else{
             
                    falseView
                        .focusEnable(!condition && hasFalseView)
                        .getContainer($falseContrainer)
                    //                    .onGetFocus{ container , manager in
                    //                        guard let manager else { return}
                    //                        guard manager.currentContainer == falseContrainer else { return}
                    //                        guard condition == true else {
                    //                            manager.go(to: trueContainer)
                    //                            return}
                    //                        guard let lastmove = manager.lastMove else {
                    //                            manager.currentContainer = actualMainContainer
                    //                            manager.goNext()
                    //                            return
                    //                        }
                    //
                    //                        if lastmove == .forward{
                    //                            manager.currentContainer = actualMainContainer
                    //                            manager.goNext()
                    //
                    //                        }else{
                    //                            manager.goPrev()
                    //                        }
                    //
                    //                    }
                    //                    .onGetFocus({ container, manager in
                    //                        guard let manager else { return}
                    //                        guard manager.currentContainer == falseContrainer else { return}
                    //                        guard condition == false else {
                    //
                    //                            return}
                    //
                    //                        guard hasFalseView else { return}
                    //
                    //                        let lastmove = manager.lastMove
                    //                        guard let lastmove else {
                    //                            manager.currentContainer = actualMainContainer
                    //                            manager.goNext()
                    //                            return}
                    //                        if lastmove == .forward{
                    //                            manager.currentContainer = actualMainContainer
                    //                            manager.goNext()
                    //
                    //                        }else{
                    //                            manager.go(to: mainContainer?.prevFocus)
                    //                        }
                    //                    })
                    //                    ./*focusEnable*/(enableFalse)
                        .myFocus(IfState.wrong)
//                        .padding(-25)
                //                    .onGetFocus{ container , manager in
                //                        guard let manager else { return}
                //                        guard manager.currentContainer == falseContrainer else { return}
                //                        guard condition == true else {
                //                            manager.go(to: trueContainer)
                //                            return}
                //                        guard let lastmove = manager.lastMove else {
                //                            manager.currentContainer = actualMainContainer
                //                            manager.goNext()
                //                            return
                //                        }
                //
                //                        if lastmove == .forward{
                //                            manager.currentContainer = actualMainContainer
                //                            manager.goNext()
                //
                //                        }else{
                //                            manager.goPrev()
                //                        }
                //
                //                    }
                //                    .onGetFocus({ container, manager in
                //                        guard let manager else { return}
                //                        guard manager.currentContainer == falseContrainer else { return}
                //                        guard condition == false else {
                //
                //                            return}
                //
                //                        guard hasFalseView else { return}
                //
                //                        let lastmove = manager.lastMove
                //                        guard let lastmove else {
                //                            manager.currentContainer = actualMainContainer
                //                            manager.goNext()
                //                            return}
                //                        if lastmove == .forward{
                //                            manager.currentContainer = actualMainContainer
                //                            manager.goNext()
                //
                //                        }else{
                //                            manager.go(to: mainContainer?.prevFocus)
                //                        }
                //                    })
                //                    ./*focusEnable*/(enableFalse)
           
                
                
            }
            
        }
        .frame(minWidth:0,minHeight: 0)
        //.frame(width:0,height: 0)
//        .onGetFocus{ container , manager in
//            guard let manager else { return}
//            if condition {
//                manager.go(to: trueContainer)
//            }else{
//           
//                if !hasFalseView{
//                    guard let lastmove = manager.lastMove else {
//                        manager.go(to: container?.nextFocus)
//                        return
//                    }
//                    if lastmove == .forward{
//                        manager.go(to: container?.nextFocus)
//                    }else{
//                        manager.go(to: container?.prevFocus)
//                    }
//                }else{
//                    manager.go(to: falseContrainer)
//                }
//            }
//            
//        }
//        .getContainer($mainContainer)
//        .focusEnable(isEntireFocusable)
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
