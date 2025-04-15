//
//  MyLayout.swift
//  FocusManager
//
//  Created by MohammavDev on 4/3/25.
//
import SwiftUI


public struct MyVStack: Layout {
    let spacing : CGFloat
    public init(spacing : CGFloat = 16){
        self.spacing = spacing
    }
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {

        let dimensions = proposal.replacingUnspecifiedDimensions()
        let width = dimensions.width
        let height = totalHeight(subviews: subviews)
        return CGSize(width: width, height: height)
    }
    private func totalHeight(subviews: Subviews) -> CGFloat {
        guard subviews.count > 0 else { return spacing }
        var total : CGFloat = 0
        for view in subviews{
//            let propsal = view.dimensions(in: .unspecified)
            let size = view.dimensions(in: .unspecified)
            guard size.width > 0 else { continue }
            total += size.height + spacing
        }
//        if total >= spacing {
//            total -= 0
//        }
        return total
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {

        logger.info("I am running with : \(String(describing: proposal))")
        var currentY : CGFloat = bounds.minY
        for index in subviews.indices {
            
            let dimensions = subviews[index].dimensions(in:.infinity)
            let actualWidth : CGFloat = dimensions.width == .infinity ? bounds.width : dimensions.width
            let actualHeight : CGFloat = subviews[index].dimensions(in:.unspecified).height
            
            let proposal = ProposedViewSize(width: actualWidth, height: actualHeight)
            
            let isEmpty = actualWidth <= 0 || actualHeight <= 0
            let point = CGPoint(x: bounds.minX, y: currentY)
            subviews[index].place(at: point, anchor: .topLeading, proposal: proposal)
            if !isEmpty {
                
                currentY = currentY + spacing + dimensions.height
            }else{
                logger.info("Found an empty view at index : \(index)")
            }
        }
    }
 
}
