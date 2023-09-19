//
//  View.swift
//
//
//  Created by Kamil Strzelecki on 19/09/2023.
//

import SwiftUI

extension View {
    @ViewBuilder
    func modify<Content: View>(
        @ViewBuilder transform: (Self) -> Content?
    ) -> some View {
        if let content = transform(self), !(content is EmptyView) {
            content
        } else {
            self
        }
    }
}
