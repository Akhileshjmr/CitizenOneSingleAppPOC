import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

/// Returns cleaned HTML (with empty tags/inline spacing removed).
/// Use this if rendering via flutter_html's Html() widget.
String cleanHtml(String rawHtml) {
  final document = html_parser.parse(rawHtml);

  bool isEffectivelyEmpty(dom.Element el) {
    final text = el.text.replaceAll('\u00A0', '').trim();
    return text.isEmpty && el.querySelector('img') == null;
  }

  document.querySelectorAll('p, div, span').forEach((el) {
    if (isEffectivelyEmpty(el)) el.remove();
  });

  document.querySelectorAll('br').forEach((el) => el.remove());

  document.querySelectorAll('*').forEach((el) {
    final style = el.attributes['style'];
    if (style != null) {
      final cleaned = style
          .split(';')
          .where((rule) =>
      !rule.contains('margin') &&
          !rule.contains('padding') &&
          !rule.contains('height'))
          .join(';');
      if (cleaned.trim().isEmpty) {
        el.attributes.remove('style');
      } else {
        el.attributes['style'] = cleaned;
      }
    }
  });

  return document.body?.innerHtml ?? rawHtml;
}

/// Extracts clean paragraph-level text from HTML for direct Text() rendering.
List<String> extractParagraphs(String rawHtml) {
  final document = html_parser.parse(rawHtml);
  final paragraphs = <String>[];

  final elements = document.querySelectorAll('p, h1, h2, h3, h4, li');

  for (final el in elements) {
    final text = el.text.replaceAll('\u00A0', ' ').trim();
    if (text.isNotEmpty) {
      paragraphs.add(text);
    }
  }

  return paragraphs;
}