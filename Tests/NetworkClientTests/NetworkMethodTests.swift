import Testing
@testable import NetworkClient

struct NetworkMethodTests {
    
    @Test
    func testDeleteMethod() {
        #expect(NetworkMethod.delete.rawValue == "DELETE")
    }
    
    @Test
    func testGetMethod() {
        #expect(NetworkMethod.get.rawValue == "GET")
    }
    
    @Test
    func testPatchMethod() {
        #expect(NetworkMethod.patch.rawValue == "PATCH")
    }
    
    @Test
    func testPostMethod() {
        #expect(NetworkMethod.post.rawValue == "POST")
    }
    
    @Test
    func testPutMethod() {
        #expect(NetworkMethod.put.rawValue == "PUT")
    }
}
