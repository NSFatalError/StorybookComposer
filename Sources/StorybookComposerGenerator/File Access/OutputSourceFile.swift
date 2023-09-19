//
//  OutputSourceFile.swift
//
//
//  Created by Kamil Strzelecki on 16/09/2023.
//

import Foundation

struct OutputSourceFile {
    let path: String

    func save(codeGenerationContext: CodeGenerationContext) throws {
        let code = codeGenerationContext.finalize()

        guard let data = code.data(using: .utf8)
        else { throw CodeGenerationError.unableToEncodeSourceCode }

        let url = URL(filePath: path)
        try data.write(to: url)
    }
}

fileprivate enum CodeGenerationError: Error {
    case unableToEncodeSourceCode
}
