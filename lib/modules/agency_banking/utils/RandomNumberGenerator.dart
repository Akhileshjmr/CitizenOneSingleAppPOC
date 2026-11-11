import 'dart:math';

class RandomNumberGenerator {
  static String generateId(String prefix, int length) {
    final random = Random();
    String randomNumber =
        List.generate(length, (_) => random.nextInt(10).toString()).join();
    return '$prefix$randomNumber';
  }
}
