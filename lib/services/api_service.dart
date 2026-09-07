/// Abstraction for the future Artinium backend (FastAPI + PostgreSQL).
/// [MockApiService] is used until a real HTTP client implementation is
/// swapped in — no other code should depend on the mock directly.
abstract class ApiService {
  Future<Map<String, dynamic>> get(String path);
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body);
}

class MockApiService implements ApiService {
  @override
  Future<Map<String, dynamic>> get(String path) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {'path': path, 'mock': true};
  }

  @override
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {'path': path, 'echo': body, 'mock': true};
  }
}
