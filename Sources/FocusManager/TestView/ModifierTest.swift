//
//  ModifierTest.swift
//  FocusManager
//
//  Created by MohammavDev on 4/11/25.
//

import SwiftUI

struct ModifierTest: View {
    var body: some View {
        VStack(spacing:30){
         
            MyVStack(spacing:30){
                Text("Some thing")
                
                Text("some other thing")
                    .frame(width:0,height:0)
                Button("Tap"){
                    
                }
                Image(systemName: "plus")
            }
       
        }
    }
}
#Preview {
    ModifierTest()
}
