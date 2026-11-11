// =============================================================================
// NetworkInfo  —  Connectivity abstraction
// -----------------------------------------------------------------------------
// In a real app this wraps `connectivity_plus` so repositories can decide
// to read from cache when offline. The POC implementation always returns
// `true` and exists to demonstrate the dependency boundary — a swap-in
// fake (e.g. for tests) requires no production code change.
// =============================================================================

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl();
  @override
  Future<bool> get isConnected async => true;
}
