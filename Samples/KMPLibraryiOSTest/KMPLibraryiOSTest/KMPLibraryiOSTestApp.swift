//
//  KMPLibraryiOSTestApp.swift
//  KMPLibraryiOSTest
//
//  Created by Ernesto Olalla on 28/4/26.
//

import SwiftUI
import KmpProductsLib

@main
struct KMPLibraryiOSTestApp: App {
    init() {
        initializeKmpLib()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
