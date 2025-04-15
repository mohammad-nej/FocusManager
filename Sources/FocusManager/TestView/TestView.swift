//
//  TestView.swift
//  FocusManager
//
//  Created by MohammavDev on 3/16/25.
//

import SwiftUI


enum BirthDay : FocusableFeilds{
    
    
    case day , month , year
}



struct ExampleView : View {
    
    enum Fields : FocusableFeilds {
        case name , family , birthDay , age
        static var initialFocusState: ExampleView.Fields?{
            .family
        }
    }
    
    enum BirthDay : FocusableFeilds {
        case day , month , year
        static var initialFocusState: ExampleView.BirthDay{
            .month
        }
    }
    
    
    @State private var name : String = ""
    @State private var family : String = ""
    
    @State private var day : String = ""
    @State private var month : String = ""
    @State private var year : String = ""
    
    @State private var age : String = ""
    
    private let manager = FocusManager(for: Fields.self)
    var body : some View {
        VStack{
            
            HStack{
                Button("Go Next"){
                    manager.goNext()
                }
                Button("Go Prev"){
                    manager.goPrev()
                }
            }
            TextField("Name", text: $name)
                .myFocus(Fields.name)
            TextField("Family", text: $family)
                .myFocus(Fields.family)
            
            HStack{
                TextField("Day", text: $day)
                    .myFocus(BirthDay.day)
                TextField("Month", text: $month)
                    .myFocus(BirthDay.month)

                TextField("Year", text: $year)
                    .myFocus(BirthDay.year)
            }.myFocus(Fields.birthDay)
            
            TextField("Age", text: $age)
                .myFocus(Fields.age)
            
        }.focusManager(manager)
            .textFieldStyle(.roundedBorder)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    manager.goToFirstElement()
                }
            }
    }
    
    
}
#Preview {
    ExampleView()
}

//struct TestView : View {
//    
//    enum Feilds : String, FocusableFeilds , CaseIterable {
//      
//        
//        var lastElement: TestView.Feilds?{
//            .last
//        }
//        
//        case first , second , third, last
//    }
//    
//    enum InnerFeilds : String,FocusableFeilds , CaseIterable {
//        case forth , fitfth
//        var lastElement: TestView.InnerFeilds?{
//            .fitfth
//        }
//    }
//    
//     @State var text = ""
//     @State var text1 = ""
//     @State var text2 = ""
//    
//    @State var text3 = ""
//    @State var text4 = ""
//    
//    @State private var stateManager : StateManager? = nil
//    @State var currentFocus : (any FocusableFeilds)? = nil
//    
//    @State var focusContainer : FocusContainer? = nil
//    
//    
//    
//    var body: some View {
//        ScrollView{
//            Text(currentFocus?.hashValue.description ?? "No Focus")
//            Text(focusContainer.debugDescription)
//            VStack{
//                TextField("First", text: $text)
//                    .myFocusValue(Feilds.first)
//                TextField("Second", text: $text1)
//                    .myFocusValue(Feilds.second)
//       
//                .background(.red, in: .rect)
////                .myFocusValue(Feilds.third)
//                    .padding(.horizontal,30)
//                
//                    TextField("Third", text: $text2)
//                        
////                        .modifier(ContainerManagerVM(container: $focusContainer))
//                        .myFocusValue(Feilds.third)
//                
////                    .myFocusValue(Feilds.last)
//            }.textFieldStyle(.roundedBorder)
////                .focusManager($stateManager)
////                .environment(\.currentlyFocusedView, $currentFocus)
//                .lineLimit(100)
//            Button("Move Focus"){
//                
//                focusContainer = focusContainer?.nextFocus
//                    
//                currentFocus = focusContainer?.myFocus
//                    
//               
//            }
//        }
//    }
//    
//}
//#Preview {
//    @Previewable @State var text = ""
//    @Previewable @State var text1 = ""
//    @Previewable @State var text2 = ""
//    TestView()
//}
