//
//  ButtonsStack.swift
//  Movies
//
//  Created by Olga Sabadina on 24.01.2024.
//

import AsyncDisplayKit

class ButtonsStack: ASDisplayNode {
    
    private var buttonsArray: [ASDisplayNode] = []
    private var actionBtn: ((ButtonsConvenienе) -> Void)?
    
    init(actionBtn: ((ButtonsConvenienе) -> Void)?) {
        self.actionBtn = actionBtn
        super.init()
        setButtons()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var result: [ASLayoutElement] = []
        
        buttonsArray.forEach { butt in
            let element = ASWrapperLayoutSpec(layoutElement: butt)
            element.style.width = .init(unit: .fraction, value: 0.23)
            result.append(element)
        }
        
        let stack = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .start, alignItems: .stretch, children: result)
      
        stack.style.width = .init(unit: .fraction, value: 1)
        
        let stackInsets = ASInsetLayoutSpec(insets: .init(top: 10, left: 16, bottom: 10, right: 16), child: stack)
     
        return stackInsets
    }
    
    private func setButtons() {
        ButtonsConvenienе.allCases.forEach { button in
            let buttonConvenient = ConvenieceButton(type: button, actionCompletion: actionBtn)
            buttonsArray.append(buttonConvenient)
        }
    }
}

enum ButtonsConvenienе: CaseIterable {
    case myList, favourite, watchList, rate
    
    var imageBtn: UIImage? {
        switch self {
        case .myList:
            return UIImage(systemName: "list.bullet")
        case .favourite:
            return UIImage(systemName: "heart")
        case .watchList:
            return UIImage(systemName: "bookmark")
        case .rate:
            return UIImage(systemName: "star")
        }
    }
    
    var title: String {
        switch self {
        case .myList:
            return "My Lists"
        case .favourite:
            return "Favorite"
        case .watchList:
            return "Watchlist"
        case .rate:
            return "Rate"
        }
    }
}
