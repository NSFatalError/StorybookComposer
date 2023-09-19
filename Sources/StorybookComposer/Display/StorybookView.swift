//
//  StorybookComponentList.swift
//
//
//  Created by Kamil Strzelecki on 16/09/2023.
//

import SwiftUI

public struct StorybookView {
    public init() {}
}

public struct StorybookComponentRow<Provider: StorybookComponentProviding>: View {
    private let provider: Provider

    public init(provider: Provider) {
        self.provider = provider
    }

    public var body: some View {
        NavigationLink(provider.name) {
            StorybookComponentPreview(provider: provider)
        }
    }
}
