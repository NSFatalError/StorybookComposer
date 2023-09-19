//
//  StorybookComponentPreview.swift
//
//
//  Created by Kamil Strzelecki on 19/09/2023.
//

import SwiftUI

struct StorybookComponentPreview<Provider: StorybookComponentProviding>: View {
    let provider: Provider
    @State private var showsInfoSheet = false

    var body: some View {
        provider
            .preview()
            .toolbar {
                Button {
                    showsInfoSheet = true
                } label: {
                    Image(systemName: "info.circle")
                }
            }
            .sheet(isPresented: $showsInfoSheet) {
                StorybookComponentInfoSheet(
                    sourceLocaiton: provider.sourceLocation
                )
            }
            .navigationTitle(provider.name)
    }
}

struct StorybookComponentInfoSheet: View {
    let sourceLocaiton: StorybookComponentSourceLocation
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Source location") {
                    row(title: "Path", value: sourceLocaiton.path)
                    row(title: "Line", value: sourceLocaiton.line)
                }
            }
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
            .navigationTitle("Info")
        }
    }

    private func row(title: String, value: CustomStringConvertible) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
            Text(String(describing: value))
                .foregroundStyle(.secondary)
                .font(.body.monospaced())
        }
    }
}

#Preview {
    NavigationStack {
        StorybookComponentPreview(
            provider: StorybookComponentProvider.mock
        )
    }
}
