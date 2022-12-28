//
//  HideKeyboardExtension.swift
//  Devote
//
//  Created by Anastasia Karunos on 11/1/22.
//

import SwiftUI

#if canImport(UIKit)

extension View {
    func hideKeybaord() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
