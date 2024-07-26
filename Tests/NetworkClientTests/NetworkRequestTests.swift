import Testing
@testable import NetworkClient

struct NetworkRequestTests {
    
    private var sut: NetworkClient.Request!
    
    @Test
    func throwsInvalidUrlError_givenNilUrlPassed() async {
        await #expect(throws: NetworkError.invalidURL, performing: {
            try await NetworkClient.Request(
                url: "",
                method: .post,
                headers: ["header1": "1"],
                body: EncodableBody(),
                paremeters: ["parameter": "value"])
            .run()
        })
    }
    
    @Test
    func throwsUnexpectedStatusCode_givenStatusReceived() async {
        await #expect(throws: NetworkError.invalidURL, performing: {
            try await NetworkClient.Request(
                url: "http://www.google.com",
                method: .post,
                headers: ["header1": "1"],
                body: EncodableBody(),
                paremeters: ["parameter": "value"])
            .run()
        })
    }
}

extension NetworkRequestTests {
    struct EncodableBody: Encodable {
        let value = "Body"
    }
}
