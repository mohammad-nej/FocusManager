//
//  ContainerBuilder.swift
//  FocusManager
//
//  Created by MohammavDev on 3/19/25.
//


@MainActor  final class ContainerBuilder {
    let allCase : [any FocusableFeilds]
     init(allCases : [any FocusableFeilds]){
        self.allCase = allCases
    }
     func build() -> [FocusContainer] {
        var all :  [FocusContainer] = []
        var result : FocusContainer?
        for item in allCase {
            all.append(.init(current: item))
        }
        for index in 0..<all.count - 1 {
            all[index].nextFocus = all[index + 1]
        }
        for index in 1..<all.count  {
            all[index].prevFocus = all[index - 1]
        }
        return all
    }
}
 extension ContainerBuilder {

    convenience init(_ sample : any FocusableFeilds){
        let all = type(of: sample).allCases.compactMap { value in
            value as? (any FocusableFeilds)
        }
        self.init(allCases: all)
    }
}
