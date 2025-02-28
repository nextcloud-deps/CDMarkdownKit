// swift-tools-version:5.7
//
//  Package.swift
//  CDMarkdownKit
//
//  Created by Christopher de Haan on 05/07/2017.
//
//  Copyright © 2016-2022 Christopher de Haan <contact@christopherdehaan.me>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import PackageDescription

let package = Package(name: "CDMarkdownKit",
                      platforms: [.macOS(.v10_13),
                                  .iOS(.v15),
                                  .tvOS(.v11),
                                  .watchOS(.v4)],
                      products: [.library(name: "CDMarkdownKit",
                                          targets: ["CDMarkdownKit"])],
                      targets: [.target(name: "CDMarkdownKit",
                                        path: "Source",
                                        exclude: ["Info.plist"],
                                        linkerSettings: [.linkedFramework("Foundation",
                                                                          .when(platforms: [.macOS,
                                                                                            .iOS,
                                                                                            .tvOS,
                                                                                            .watchOS])),
                                                         .linkedFramework("Cocoa",
                                                                          .when(platforms: [.macOS])),
                                                         .linkedFramework("UIKit",
                                                                          .when(platforms: [.iOS,
                                                                                            .tvOS,
                                                                                            .watchOS]))])],
                      swiftLanguageVersions: [.v5])
