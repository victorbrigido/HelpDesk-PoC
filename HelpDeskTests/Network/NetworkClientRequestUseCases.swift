//
//  NetworkClientRequestUseCases.swift
//  HelpDeskTests
//
//  Created by Joao Rocha on 24/07/24.
//

import XCTest
@testable import HelpDesk

final class NetworkClientRequestUseCases: XCTestCase {

    func test_request_resume_dataTask_with_url() {
        let session = URLSessionSpy()
        let sut = NetworkService(session: session)
        let url = URL(string: "https://localhost:3000/")!
        let task = URLSessionDataTaskSpy()
        
        session.stub(url: url, task: task)
        sut.request(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCount, 1)
    }

}

final class URLSessionSpy: URLSession {

    private(set) var stubs: [URL: Stub] = [:]
    
    struct Stub {
        let tasks: URLSessionDataTask
        let error: Error?
        let data: Data?
        let response: URLResponse?
    }

    func stub(url: URL, task: URLSessionDataTask, error: Error? = nil, data: Data? = nil, response: URLResponse? = nil) {
        stubs[url] = Stub(tasks: task, error: error, data: data, response: response)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        guard let stub = stubs[url] else {
            return FakeURLSessionDataTask()
        }
        completionHandler(stub.data, stub.response, stub.error)
        return stub.tasks
    }

}

final class URLSessionDataTaskSpy: URLSessionDataTask {
    private(set) var resumeCount: Int = .zero

    override func resume() {
        resumeCount += 1
    }

}

final class FakeURLSessionDataTask: URLSessionDataTask {

    override func resume() { }

}
