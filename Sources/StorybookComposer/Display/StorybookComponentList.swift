//
//  StorybookComponentList.swift
//  
//
//  Created by Kamil Strzelecki on 19/09/2023.
//

import SwiftUI

public struct StorybookComponentList<Rows: View>: View {
    private let rows: () -> Rows

    public init(@ViewBuilder rows: @escaping () -> Rows) {
        self.rows = rows
    }

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 0) {
                        SwiftBar()
                        Group {
                            Text("This list was generated using\n")
                            + Text("StorybookComposer\n").font(.body.monospaced().bold())
                            + Text("by Kamil Strzelecki").font(.body.italic())
                        }
                        .padding()
                        .multilineTextAlignment(.center)
                        .layoutPriority(1)
                    }
                }
                .listRowInsets(.init())

                Section("Components") {
                    rows()
                }
            }
            .navigationTitle("Storybook")
        }
    }
}

fileprivate struct SwiftBar: View {
    @State private var animation = 0

    var body: some View {
        ZStack {
            Color.orange
            Image(systemName: "swift")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.background)
                .frame(height: 60)
                .padding()
                .modify { symbol in
                    if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, visionOS 1, *) {
                        symbol.symbolEffect(.bounce.down, value: animation)
                    }
                }
        }
        .onReceive(
            Timer
                .publish(every: 2, on: .main, in: .common)
                .autoconnect(),
            perform: { _ in
                animation += 1
            }
        )
        .onAppear {
            animation += 1
        }
    }
}

#Preview {
    StorybookComponentList {
        StorybookComponentRow(
            provider: StorybookComponentProvider.mock
        )
    }
}
