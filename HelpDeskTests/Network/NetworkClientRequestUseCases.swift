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
        let (sut, session) = makeSUT()
        let url = URL(string: "https://localhost:3000/")!
        let task = URLSessionDataTaskSpy()
        
        session.stub(url: url, task: task)
        sut.request(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCount, 1)
    }
    
    func test_request_and_completion_with_error_for_invalidCases() {
        let url = URL(string: "https://localhost:3000/")!
        let anyError = NSError(domain: "Any error", code: -1)
        let data = Data()
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let urlResponse = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        
        XCTAssertNotNil(resultErrorForInvalidCases(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorForInvalidCases(data: nil, response: urlResponse, error: nil))
        XCTAssertNotNil(resultErrorForInvalidCases(data: nil, response: httpResponse, error: nil))
        XCTAssertNotNil(resultErrorForInvalidCases(data: data, response: nil, error: nil))
        XCTAssertNotNil(resultErrorForInvalidCases(data: data, response: nil, error: anyError))
        XCTAssertNotNil(resultErrorForInvalidCases(data: nil, response: urlResponse, error: anyError))
        XCTAssertNotNil(resultErrorForInvalidCases(data: nil, response: httpResponse, error: anyError))
        XCTAssertNotNil(resultErrorForInvalidCases(data: data, response: urlResponse, error: anyError))
        XCTAssertNotNil(resultErrorForInvalidCases(data: data, response: httpResponse, error: anyError))
        XCTAssertNotNil(resultErrorForInvalidCases(data: data, response: urlResponse, error: nil))
        
        let result = resultErrorForInvalidCases(data: nil, response: nil, error: anyError)
        XCTAssertEqual(result as? NSError, anyError)
    }
    
    func test_request_and_completion_with_success_for_validCases() {
        let url = URL(string: "https://localhost:3000/")!
        let anyError = NSError(domain: "Any error", code: -1)
        let data = Data()
        let okResponse = 200
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let result = resultErrorForValidCases(data: data, response: httpResponse, error: nil)
        
        XCTAssertEqual(result?.data, data)
        XCTAssertEqual(result?.response, httpResponse)
        XCTAssertEqual(result?.response.url, url)
        XCTAssertEqual(result?.response.statusCode, okResponse)
        
    }
    
    private func resultErrorForValidCases(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (data: Data?, response: HTTPURLResponse)? {
        let result = assert(data: data, response: response, error: error)
        
        switch result {
        case let .success((data, response)):
            return (data, response)
        default: XCTFail("expected success but returned \(result)", file: file, line: line)
        }
        return nil
    }

    private func resultErrorForInvalidCases(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Error? {
        
        let result = assert(data: data, response: response, error: error)
        
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("expected failure but returned \(String(describing: result))", file: file, line: line)
        }
        return nil
    }

    
    private func makeSUT() -> (NetworkService, URLSessionSpy) {
        let session = URLSessionSpy()
        let sut = NetworkService(session: session)
        return (sut, session)
    }

    private func assert(
            data: Data?,
            response: URLResponse?,
            error: Error?,
            file: StaticString = #filePath,
            line: UInt = #line
        ) -> NetworkService.NetworkResult? {
            let (sut, session) = makeSUT()
            let url = URL(string: "https://localhost:3000/")!
            let task = URLSessionDataTaskSpy()

            let exp = expectation(description: "waiting")
            var returnedResult: NetworkService.NetworkResult?

            session.stub(url: url, task: task, error: error, data: data, response: response)
            sut.request(from: url) { result in
                returnedResult = result
                exp.fulfill()
            }
            wait(for: [exp], timeout: 1.0)
            return returnedResult
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
