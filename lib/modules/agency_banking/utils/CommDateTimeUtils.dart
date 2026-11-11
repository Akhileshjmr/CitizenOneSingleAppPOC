import 'dart:typed_data';

import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

class CommDateTimeUtils {
  /// Converts a date string to a DateTime object.
  /// Supports two formats: 'dd/MM/yyyy' and 'yyyy-MM-dd'.
  /// Returns `null` if the parsing fails.
  ///
  ///

  static DateTime? convertsStringDateToDateFormateddmmyy(String? date) {
    if (date == null) return null; // Handle null input

    try {
      // Attempt to parse using the first format
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      return dateFormat.parse(date);
    } catch (e) {
      try {
        // If it fails, attempt to parse using the second format
        DateFormat dateFormat = DateFormat('yyyy-MM-dd');
        return dateFormat.parse(date);
      } catch (e) {
        // If all parsing fails, return null
        return null;
      }
    }
  }

  static String? formatTimestampToDateString(dynamic timestamp) {
    if (timestamp is int) {
      // Convert Unix timestamp to DateTime
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateFormat('dd MMM yyyy')
          .format(dateTime); // Example: Jan 20, 2025
    } else if (timestamp is DateTime) {
      // Format DateTime object directly
      return DateFormat('dd MMM yyyy')
          .format(timestamp); // Example: Jan 20, 2025
    }
    return null; // Return null for unsupported types
  }

  /// Returns the current date and time formatted as 'dd/MM/yyyy HH:mm:ss'.
  /// Parses it back into a `DateTime` object.
  static DateTime? getCurrentDateTime() {
    try {
      // Get the current date and time
      DateTime now = DateTime.now();

      // Format the date and time
      DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
      String formattedDate = dateFormat.format(now);

      // Parse the formatted string back into a DateTime object
      return dateFormat.parse(formattedDate);
    } catch (e) {
      // Handle any unexpected errors
      AppLogger.error('Error parsing current date/time', e);
      return null;
    }
  }

  /// opens a date picker upto current date
  static Future<void> selectDate(
      BuildContext context, TextEditingController controller,
      {Color primaryColor = Colors.blueGrey}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: primaryColor,
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: primaryColor,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = "${picked.toLocal()}".split(' ')[0];
    }
  }

  /// opens a date picker with future dates also
  static Future<void> withFutureDate(
      BuildContext context, TextEditingController controller,
      {Color primaryColor = Colors.blue}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 365 * 100)),
      // Allows future dates up to 100 years
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: primaryColor,
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: primaryColor,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = "${picked.toLocal()}".split(' ')[0];
    }
  }

  static DateTime? parseDateFromText(String input) {
    if (input.trim().isEmpty) return null;
    try {
      return DateFormat('yyyy-MM-dd').parse(input);
    } catch (e) {
      AppLogger.error('Date parse error', e);
      return null;
    }
  }

  int _intensityFromPixel(img.Pixel pixel) =>
      pixel.r.toInt(); // grayscale => r == g == b

  /// Computes average hash (aHash) of the image as a 64-bit integer.
  Future<BigInt> computeAverageHash(Uint8List bytes) async {
    final image = img.decodeImage(bytes);
    if (image == null) throw Exception("Failed to decode image for hashing.");

    final small = img.copyResize(
      image,
      width: 8,
      height: 8,
      interpolation: img.Interpolation.average,
    );
    final gray = img.grayscale(small);

    // Compute average intensity.
    int total = 0;
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        final img.Pixel pixel = gray.getPixel(x, y) as img.Pixel;
        total += _intensityFromPixel(pixel);
      }
    }
    final double avg = total / 64.0;

    // Build hash.
    BigInt hash = BigInt.zero;
    int bitIndex = 0;
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        final img.Pixel pixel = gray.getPixel(x, y) as img.Pixel;
        final int intensity = _intensityFromPixel(pixel);
        if (intensity > avg) {
          hash |= (BigInt.one << bitIndex);
        }
        bitIndex++;
      }
    }

    return hash;
  }

  /// Hamming distance between two hashes.
  int hammingDistance(BigInt a, BigInt b) {
    BigInt x = a ^ b;
    int dist = 0;
    while (x > BigInt.zero) {
      if ((x & BigInt.one) == BigInt.one) dist++;
      x = x >> 1;
    }
    return dist;
  }

  /// Returns true if images are similar within the given threshold.
  Future<bool> areImagesSimilar(Uint8List a, Uint8List b,
      {int threshold = 5}) async {
    final hashA = await computeAverageHash(a);
    final hashB = await computeAverageHash(b);
    final dist = hammingDistance(hashA, hashB);
    return dist <= threshold;
  }
}
