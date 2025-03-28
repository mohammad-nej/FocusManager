import Testing
@testable import FocusManager
//
@MainActor @Suite("Test passing Focus") struct FocusPassingTests {
    
    
    @MainActor class UIElement {
        
        static var id : Int = 0
        
        init(){
            number = Self.id + 1
            Self.id += 1
        }
        var number : Int
        
        
        var prevFocus : FocusContainer?
        var myFocus : FocusContainer?{
            didSet{
                prevFocus = myFocus?.prevFocus
                nextFocus = myFocus?.nextFocus
            }
        }
        var nextFocus : FocusContainer?
        
        var innerElements : [UIElement] = []
        
    }
    
    enum Feilds : String,FocusableFeilds , CaseIterable{
        var lastElement: Feilds?{
            return .age
        }
        
        case name , family,birthDay , age
    }
    
    enum BirthDay : String,FocusableFeilds , CaseIterable{
        var lastElement: BirthDay?{
            return .day2
        }
        
        case day2 , month , year
    }
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @MainActor @Test("Focus Container Test") func focusContainerTest() async throws {
        
        
        let family =  FocusContainer( current: Feilds.family).create()
        #expect(family.myFocus.myHash == Feilds.family.myHash)
        #expect(family.prevFocus?.myFocus.myHash == Feilds.name.myHash)
        #expect(family.nextFocus?.myFocus.myHash == Feilds.birthDay.myHash)
        
        let birthDay = FocusContainer(current: Feilds.birthDay).create()
        
        #expect(birthDay.myFocus.myHash == Feilds.birthDay.myHash)
        #expect(birthDay.prevFocus?.myFocus.myHash == Feilds.family.myHash)
        #expect(birthDay.nextFocus?.myFocus.myHash == Feilds.age.myHash)
//        let name = FocusContainer(current: Feilds.name).create()
//        let age = FocusContainer(current: Feilds.age).create()
        
        var main = UIElement()
        
        var nameEL = UIElement()
        
        var familyEl = UIElement()
        var ageEl = UIElement()
        var birthDayEl = UIElement()
        
        main.innerElements = [nameEL,familyEl,birthDayEl,ageEl]
        
        var dayEl = UIElement()
        var monthEl = UIElement()
        var yearEl = UIElement()
        
        birthDayEl.innerElements = [dayEl,monthEl,yearEl]
        
    }
    
    @Test("Container builder Test") func builderTest() async throws {
        let cases = BirthDay.allCases
        let all = ContainerBuilder(allCases: cases).build()
        
        try #require(all.count == 3)
        let container = all.first!
        
        let first = container
        #expect(first.isFocusable == true)
        #expect(first.myFocus.myHash == BirthDay.day2.myHash)
        #expect(first.nextFocus?.myFocus.myHash == BirthDay.month.myHash)
        #expect(first.hasChildren == false)
        #expect(first.parent == nil)
        #expect(first.prevFocus == nil)
        
        let second = try #require( first.nextFocus)
        #expect(second.isFocusable == true)
        #expect(second.myFocus.myHash == BirthDay.month.myHash)
        #expect(second.nextFocus?.myFocus.myHash == BirthDay.year.myHash)
        #expect(second.hasChildren == false)
        #expect(second.parent == nil)
        #expect(second.prevFocus == first)
        
        let third = try #require( second.nextFocus)
        #expect(third.isFocusable == true)
        #expect(third.myFocus.myHash == BirthDay.year.myHash)
        #expect(third.nextFocus == nil)
        #expect(third.hasChildren == false)
        #expect(third.parent == nil)
        #expect(third.prevFocus == second)
        
    }
    
    @Test("Insert under Container test") func addToContainer() async throws {
      
        
        #expect(Feilds.family.hashValue != BirthDay.month.hashValue)
        
        let modifier = FocusManager(for: Feilds.self)
        modifier.goToFirstElement()
        
        let family = try #require(modifier.find(Feilds.family, in: modifier.currentContainer))
        
        modifier.insert(BirthDay.self, under: family.myFocus)
        
        var current = modifier.initial
        
        let allCases = Feilds.allCases
        
        for feild in allCases{
            let element = try #require(modifier.find(feild, in: current))
            
            #expect(element.parent == nil)
            if element.myFocus.myHash != Feilds.family.myHash {
                #expect(element.hasChildren == false)
            }
        }
        
//        let family = try #require(modifier.find(Feilds.family, in: current))
        
        #expect(family.hasChildren == true)
        
//        #expect(family.nextFocus?.myHash == BirthDay.day2.myHash)
//        #expect(family.prevFocus?.myHash == Feilds.family.myHash)
        
        let birthDayCases = BirthDay.allCases
        try #require(birthDayCases.count == 3)
        for feild in birthDayCases{
            let element = try #require(modifier.find(feild, in: current))
            #expect(element.hasChildren == false)
            #expect(element.parent == family)
            
        }
        
        let first = try #require(modifier.find(BirthDay.day2, in: current))
        let month = try #require(modifier.find(BirthDay.month, in: current))
        let year = try #require(modifier.find(BirthDay.year, in: current))
        
        #expect(first.prevFocus == nil)
        
        #expect(first.nextFocus?.myHash == month.myHash)
        #expect(month.prevFocus?.myHash == first.myHash)
        
        let next = family.nextFocus!
        #expect(year.nextFocus == next )
        #expect(year.prevFocus == month)
        
        
        
        
    }
    @Test("Go Next") func goNext() throws {
        let modifier = FocusManager(for: Feilds.self)
        modifier.insert(BirthDay.self, under: Feilds.birthDay)
        
        modifier.goToFirstElement()
        
        var element = try #require(goNext(with: modifier))
        #expect(element.myFocus.myHash == Feilds.family.myHash)
        
        element = try #require(goNext(with: modifier))
        #expect(element.myFocus.myHash == BirthDay.day2.myHash)
        
        element = try #require(goNext(with: modifier))
        #expect(element.myFocus.myHash == BirthDay.month.myHash)
        
        element = try #require(goNext(with: modifier))
        #expect(element.myFocus.myHash == BirthDay.year.myHash)
        
        element = try #require(goNext(with: modifier))
        #expect(element.myFocus.myHash == Feilds.age.myHash)
        
        element = try #require(goNext(with: modifier))
        #expect(element.myFocus.name == "name")
        
    }
    @Test("Go Prev") func goPrev() throws {
        let modifier = FocusManager(for: Feilds.self)
        
        modifier.insert(BirthDay.self, under: Feilds.birthDay)
        
        modifier.goToFirstElement()
        
        let age = try #require(modifier.find(Feilds.age, in: modifier.currentContainer))
        modifier.go(to: age.myFocus)
        
        var element = try #require(goPrev(with: modifier))
        #expect(element.myFocus.name == BirthDay.year.name)
        
        element = try #require(goPrev(with: modifier))
        #expect(element.myFocus.myHash == BirthDay.month.myHash)
        
        element = try #require(goPrev(with: modifier))
        #expect(element.myFocus.myHash == BirthDay.day2.myHash)
        
        element = try #require(goPrev(with: modifier))
        #expect(element.myFocus.name == "family")
        
        element = try #require(goPrev(with: modifier))
        #expect(element.myFocus.myHash == Feilds.name.myHash)
        
        element = try #require(goPrev(with: modifier))
        #expect(element.myFocus.myHash == Feilds.age.myHash)
        
    }
    
    @Test("Go to First Element") func goFirstElement() throws {
        let modifier = FocusManager(for: Feilds.self)
        modifier.insert(BirthDay.self, under: Feilds.birthDay)
        
        modifier.goToFirstElement()
        
        let month = try #require(modifier.find(BirthDay.month, in: modifier.currentContainer))
        modifier.currentContainer = month
        
        modifier.goToFirstElement()
        let first = modifier.currentContainer
        
        #expect(first?.myFocus.myHash == Feilds.name.myHash)
        
        
    }
    @Test("Go to Last Element") func goLastElement() throws {
        let modifier = FocusManager(for: Feilds.self)
        modifier.goToLastElement()
        
        let last = try #require(modifier.currentContainer)
        
        #expect(last.myFocus.myHash == Feilds.age.myHash)
        
        modifier.goToLastElement()
        #expect(last.myFocus.myHash == Feilds.age.myHash)
    }
    @Test("Go to specific element") func goToSpecificElement() throws {
        let modifier = FocusManager(for: Feilds.self)
        modifier.go(to: Feilds.family)
        let current = try #require(modifier.currentContainer)
    
        #expect(current.myFocus.myHash == Feilds.family.myHash)
    }
    @Test("Go to inner element") func goToInnerrElement() throws {
        let modifier = FocusManager(for: Feilds.self)
        modifier.insert(BirthDay.self, under: Feilds.birthDay)
        
        modifier.go(to: Feilds.birthDay)
            
        let current = try #require(modifier.currentContainer)
        #expect(current.myFocus.name == "day2")
    }
    func goPrev(with modifier : FocusManager) -> FocusContainer?{
        modifier.goPrev()
        return modifier.currentContainer
    }
    func goNext(with modifier : FocusManager) -> FocusContainer?{
        modifier.goNext()
        return modifier.currentContainer
    }
    
    func passFocus(_ focus : FocusContainer , to element : UIElement){
        element.myFocus = .init(current: focus.myFocus)
        
        
    }
    
    
}
