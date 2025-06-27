enum ApiStatus {
  initial,
  loading,
  success,
  clientError, // 400-499
  serverError, // 500-599
  networkError,
  unknownError,
}
