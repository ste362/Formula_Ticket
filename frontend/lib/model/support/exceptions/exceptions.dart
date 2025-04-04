class MailAlreadyExistsException implements Exception {
  String errMsg() => 'Mail Already Exists in database';
}


class ProductQuantityUnavailableException implements Exception {
  String errMsg() => 'Product quantity unavailable!';
}