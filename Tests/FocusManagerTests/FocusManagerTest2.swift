////
////  FocusManagerTest2.swift
////  FocusManager
////
////  Created by MohammavDev on 3/25/25.
////
//import Testing
//@testable import FocusManager
//
//
//@MainActor @Suite("Focus Manager Test 2 (in Depth)") struct FocusManagerTest2 {
//    
//    
//    enum Feilds2 : FocusableFeilds {
//        case name , family , details , age
//        
//        static var initialFocusState: FocusManagerTest2.Feilds2? { .family}
//    }
//    
//    enum Birthday2 : FocusableFeilds {
//        case year , month , day
//        
//        static var initialFocusState: FocusManagerTest2.Birthday2? { .month}
//    }
//    
//    enum Address2 : FocusableFeilds {
//        case city , country
//        
//        static var initialFocusState: FocusManagerTest2.Address2? { .country}
//    }
//    
//    enum Feilds : FocusableFeilds {
//        case name , family , details , age
//    }
//    
//    enum Birthday : FocusableFeilds {
//        case year , month , day
//    }
//    enum Address : FocusableFeilds {
//        case city , country
//    }
//    
//    @Test("Test a view with multiple children") func testMultipleChildren() async throws {
//        let manager = FocusManager(for: Feilds.self)
//        manager.insert(Address.self, under: Feilds.details)
//        manager.insert(Birthday.self, under: Feilds.details)
//       
//        manager.goToFirstElement()
//        let details = try #require(manager.find(Feilds.details, in: manager.initial))
//        
//        #expect(details.hasChildren)
//        try #require (details.children.count == 2)
//        #expect(details.children[0].myFocus.name == "year")
//        #expect(details.children[1].myFocus.name == "city")
//        
//        let firstChildPrev = details.children[0].prevFocus
//        
//        let day = try #require(manager.find(Birthday.day, in: manager.initial))
//        let firstChildLastElementsNextPointer = day.nextFocus
//        
//        
//        
//        #expect(firstChildPrev == nil)
//        #expect(firstChildLastElementsNextPointer?.myFocus.name == "nil")
//        
//        let city = try #require(manager.find(Address.city, in: manager.initial))
//        let country = try #require(manager.find(Address.country, in: manager.initial))
//        
//        let secondChildLastElementsNextPointer = country.nextFocus
//        
//        #expect(city.prevFocus?.myFocus.name == "day")
//        #expect(secondChildLastElementsNextPointer?.myFocus.name == "age")
//    }
//    
//    @Test("Going forward in view with multiple children") func testMultipleChildrenForward() async throws {
//        let manager = FocusManager(for: Feilds.self)
//        manager.insert(Address.self, under: Feilds.details)
//
//        manager.insert(Birthday.self, under: Feilds.details)
//                
//        manager.go(to: Feilds.family)
//        #expect(manager.currentFocus?.name == "family")
//        
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "year")
//        
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "month")
//        
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "day")
//        
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "city")
//        
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "country")
//        
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "age")
//        
//    }
//    
//    @Test("Going forward with initialSelect element enabled") func testMultipleChildrenForwardWithInitialSelect() async throws {
//        let manager = FocusManager(for: Feilds2.self)
//        manager.insert(Address2.self, under: Feilds2.details)
//        manager.insert(Birthday2.self, under: Feilds2.details)
//     
//        
//        manager.go(to: Feilds2.family)
//        
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "month")
//        
//        manager.goPrev()
//        #expect(manager.currentFocus?.name == "year")
//        
//        manager.goPrev()
//        #expect(manager.currentFocus?.name == "family")
//        
//        manager.goNext()
//        manager.goNext()
//        
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "country")
//        
//        manager.goPrev()
//        #expect(manager.currentFocus?.name == "city")
//        
//        manager.goNext()
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "age")
//        
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "family")
//        
//    }
//    
//    @Test("Jumping over disabled focus elements while moving around") func jumpingOverDisabledElements() async throws {
//        
//        let manager = FocusManager(for: Feilds2.self)
//        manager.insert(Address2.self, under: Feilds2.details)
//        manager.insert(Birthday2.self, under: Feilds2.details)
//       
//        
//        let family = try #require(manager.find(Feilds2.family, in: manager.initial))
//        family.isFocusable = false
//        
//        let age = try #require(manager.find(Feilds2.age, in: manager.initial))
//        age.isFocusable = false
//        
//        let day = try #require(manager.find(Birthday2.day , in: manager.initial))
//        day.isFocusable = false
//        
//        
////        manager.goNext()
////        #expect(manager.currentFocus?.name == "name")
//        
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "month")
//        
//        manager.goPrev()
//        #expect(manager.currentFocus?.name == "year")
//        
//        manager.goPrev()
//        #expect(manager.currentFocus?.name == "name")
//        
//        manager.go(to: Feilds2.family)
//        #expect(manager.currentFocus?.name == "month")
//        
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "country")
//        
//        manager.goNext()
//        #expect(manager.currentFocus?.name == "month")
//        
//        manager.goPrev()
//        #expect(manager.currentFocus?.name == "year")
//        
//        manager.goPrev()
//        #expect(manager.currentFocus?.name == "name")
//        
//        manager.goToLastElement()
//        #expect(manager.currentFocus?.name == "country")
//        
//        manager.goToFirstElement()
//        #expect(manager.currentFocus?.name == "month")
//        
//        let name = manager.find(Feilds2.name, in: manager.initial)
//        name?.isFocusable = false
//        
//        manager.goToFirstElement()
//        #expect(manager.currentFocus?.name == "month")
//
//        
//    }
//    
//    @Test("What if everything is disabled?!") func everythingDisabled() {
//        let manager = FocusManager(for: Address.self)
//        
//        
//        manager.goToFirstElement()
//        
//        let city = manager._currentContainer!
//        city.isFocusable = false
//        
//        let country = manager._currentContainer?.nextFocus!
//        country?.isFocusable = false
//        manager.unFocus()
//        
//        manager.goNext()
//        #expect(manager.currentFocus == nil)
//        
//        
//    }
//}
