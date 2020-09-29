//
//  RedditTests.swift
//  RedditTests
//
//  Created by Sumitha Palanisamy on 9/28/20.
//

import XCTest
@testable import Reddit

class RedditTests: XCTestCase {
    var posts: [Post] = []
    override func setUpWithError() throws {
        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: "MockData", ofType: "json") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
                let decoder = JSONDecoder()
                let response = try? decoder.decode(Container<Listing<Post>>.self, from: jsonData)
                posts = response?.data.children.map({ $0.data }) ?? []
            }
        }
    }

    func testNumberofPostInMockData() {
        XCTAssertEqual(posts.count, 2)
        
    }
    
    func testTheTitleofAPost() {
        let postTitle1 = posts[0].title
        XCTAssertEqual(postTitle1, "What was normal in 2000, but strange in 2020?")
        let postTitle2 = posts[1].title
        XCTAssertEqual(postTitle2, "Florida PD tackles Trump campaign manager Brad Parscale")
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        posts = []
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
