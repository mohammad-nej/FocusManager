# Getting Started


In this article we will see how can you start using this package to control Focus in your applications


## Defining Types

In order for the ``FocusManager`` to be able to travers your views, you must create a type conforming to ``FocusableFeilds`` protocols.

let's assume that this is our initial view :
```swift
struct ExampleView : View {

    @State private var name : String = ""
    @State private var family : String = ""
    @State private var age : String = ""

    var body : some View {
        VStack{
            TextField("Name", text: $name)
            TextField("Family", text: $family)
            TextField("Age", text: $age)
        }
        .textFieldStyle(.roundedBorder)
    }
}
```
All we need to is to create an `Enum` conforming to ``FocusableFeilds``
```swift
enum Fields : FocusableFeilds{
    case name , family , age
}
```
Now we should create a manager for our view 
```swift
    let manager = FocusManager(Fields.self)
```
now we should assign our `Fields` to their related views
```swift
var body : some View {
    VStack{
        TextField("Name", text: $name)
            .myFocus(Fields.name)
        TextField("Family", text: $family)
            .myFocus(Fields.family)
        TextField("Age", text: $age)
            .myFocus(Fields.age)
    }
    .textFieldStyle(.roundedBorder)
}

```

At last we have to insert `manager` object into the `Environment` using ``SwiftUICore/View/focusManager(_:)`` modifier:
```swift
var body : some View {
    VStack{
        TextField("Name", text: $name)
            .myFocus(Fields.name)
        TextField("Family", text: $family)
            .myFocus(Fields.family)
        TextField("Age", text: $age)
            .myFocus(Fields.age)
    }
    .textFieldStyle(.roundedBorder)
    .focusManager(manager)
}
```
Thats' it. Now you can use `manager` object to control focus in your view. your final view code should end up like this
```swift
struct ExampleView : View {
    
    enum Fields : FocusableFeilds {
        case name , family , age
    }
    @State private var name : String = ""
    @State private var family : String = ""

    @State private var age : String = ""
    
    private let manager = FocusManager(for: Fields.self)
    var body : some View {
        VStack{
            TextField("Name", text: $name)
                .myFocus(Fields.name)
            TextField("Family", text: $family)
                .myFocus(Fields.family)
            TextField("Age", text: $age)
                .myFocus(Fields.age)
        }.focusManager(manager)
            .textFieldStyle(.roundedBorder)
    } 
}
```

