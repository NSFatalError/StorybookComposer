//
//  StorybookComponent.swift
//
//
//  Created by Kamil Strzelecki on 08/09/2023.
//

import SwiftUI

@attached(member, names: named(storybookComponentPreview), named(_storybookComponentProvider))
public macro StorybookComponent() = #externalMacro(
    module: "StorybookComposerMacrosPlugin",
    type: "StorybookComponentMacro"
)
