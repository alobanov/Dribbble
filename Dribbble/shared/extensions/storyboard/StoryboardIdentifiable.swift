//
//  StoryboardIdentifiable.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 21.07.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
