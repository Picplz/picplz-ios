//
//  DIContainerProvider.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Swinject
import os

final class DIContainerProvider {
    static let shared = DIContainerProvider()

    private let assembler: Assembler

    var resolver: Resolver { assembler.resolver }

    private init() {
        self.assembler = .init([
            DataLayerAssembly(),
            UseCasesAssembly(),
            ViewModelsAssembly(),
            ViewControllersAssembly()
        ])

        let logger = Logger.of("DIContainerProvider")
        logger.debug("DIContainerProvider init completed")
    }
}
