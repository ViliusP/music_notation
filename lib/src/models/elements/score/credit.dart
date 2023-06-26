import 'package:music_notation/src/models/elements/image.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/elements/bookmark.dart';
import 'package:music_notation/src/models/elements/link.dart';
import 'package:music_notation/src/models/elements/text/text.dart';

/// The credit type represents the appearance of the title, composer, arranger, lyricist, copyright, dedication, and other text, symbols, and graphics that commonly appear on the first page of a score.
///
/// The credit-words, credit-symbol, and credit-image elements are similar to the words, symbol, and image elements for directions.
///
/// However, since the credit is not part of a measure, the default-x and default-y attributes adjust the origin relative to the bottom left-hand corner of the page.
/// The enclosure for credit-words and credit-symbol is none by default.
///
/// By default, a series of credit-words and credit-symbol elements within a single credit element follow one another in sequence visually.
/// Non-positional formatting attributes are carried over from the previous element by default.
///
/// The page attribute for the credit element specifies the page number where the credit should appear.
///
/// This is an integer value that starts with 1 for the first page.
/// Its value is 1 by default. Since credits occur before the music,
/// these page numbers do not refer to the page numbering specified by the print element's page-number attribute.
///
/// The credit-type element indicates the purpose behind a credit.
/// Multiple types of data may be combined in a single credit, so multiple elements may be used.
///
/// Standard values include page number, title, subtitle, composer, arranger, lyricist, rights, and part name.
sealed class Credit {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  final List<String> creditTypes;
  final List<Link> links;
  final List<Bookmark> bookmarks;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Specifies the page number where the credit should appear.
  ///
  /// This is an integer value that starts with 1 for the first page.
  /// Its value is 1 if not specified.
  ///
  /// Since credits occur before the music, these page numbers do not refer to
  /// the page numbering specified by the <print> element's page-number attribute.
  final int page;

  /// Specifies an ID that is unique to the entire document.
  final String? id;

  Credit({
    this.creditTypes = const [],
    this.links = const [],
    this.bookmarks = const [],
    this.page = 1,
    this.id,
  });

  factory Credit.fromXml(XmlElement xmlElement) {
    // Validate and check if sequence is TextCredit sequence;
    try {
      return TextCredit.fromXml(xmlElement);
    } catch (e) {
      if (e.runtimeType != InvalidXmlSequence) {
        rethrow;
      }
    }
    // Validate and check if sequence is ImageCredit sequence;
    try {
      return ImageCredit.fromXml(xmlElement);
    } catch (e) {
      if (e.runtimeType != InvalidXmlSequence) {
        rethrow;
      }
    }
    throw XmlElementContentException(
      message:
          "Credit must have 'credit-image' or <credit-words> or <credit-symbol>.",
      xmlElement: xmlElement,
    );
  }

  static int _pageFromXml(XmlElement xmlElement) {
    String? rawPage = xmlElement.getAttribute("page");
    int? page = int.tryParse(rawPage ?? "");
    if (rawPage != null && (page == null || page < 1)) {
      throw MusicXmlFormatException(
        message:
            "'page' attribute in 'credit' element must be positive integer",
        xmlElement: xmlElement,
        source: rawPage,
      );
    }
    page ??= 1;
    return page;
  }

  XmlElement toXml() {
    throw UnimplementedError();
  }
}

class NextCredit {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  List<Link> links;

  List<Bookmark> bookmarks;

  CreditText creditText;

  NextCredit({
    this.links = const [],
    this.bookmarks = const [],
    required this.creditText,
  });
}

class TextCredit extends Credit {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  CreditText value;

  List<NextCredit> nextCredits;

  TextCredit({
    required this.value,
    this.nextCredits = const [],
    super.creditTypes = const [],
    super.links = const [],
    super.bookmarks = const [],
    super.page = 1,
    super.id,
  });

  static (int nextIndex, NextCredit? credit) _parseCredit({
    required List<XmlElement> childElements,
    required int startFrom,
  }) {
    List<Link> links = [];
    List<Bookmark> bookmarks = [];
    CreditText? text;

    int index = startFrom;
    while (index < childElements.length) {
      XmlElement child = childElements[index];

      if (text == null && child.name.local == 'link') {
        links.add(Link.fromXml(child));
        index++;
      }
      if (text == null && child.name.local == 'bookmark') {
        bookmarks.add(Bookmark.fromXml(child));
        index++;
      }
      if (text == null && child.name.local == 'credit-words') {
        text = CreditWords.fromXml(child);
        index++;
        break;
      }
      if (text == null && child.name.local == 'credit-symbol') {
        text = CreditSymbol.fromXml(child);
        index++;
        break;
      }
    }

    if (text != null) {
      return (
        index,
        NextCredit(creditText: text, bookmarks: bookmarks, links: links)
      );
    }
    return (index, null);
  }

  /// not used directly
  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'credit-type': XmlQuantifier.zeroOrMore,
    'link': XmlQuantifier.zeroOrMore,
    'bookmark': XmlQuantifier.zeroOrMore,
    'credit-words|credit-symbol': XmlQuantifier.required,
    {
      'link': XmlQuantifier.zeroOrMore,
      'bookmark': XmlQuantifier.zeroOrMore,
      'credit-words|credit-symbol': XmlQuantifier.required,
    }: XmlQuantifier.zeroOrMore,
  };

  factory TextCredit.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);
    Iterable<XmlElement> creditTypeElements = xmlElement.findElements(
      'credit-type',
    );

    List<String> creditTypes = creditTypeElements.map((type) {
      String? content = type.firstChild?.value;
      if (content == null || content.isEmpty) {
        throw XmlElementContentException(
          message: "'credit-type' must have non-empty string content",
          xmlElement: type,
        );
      }
      return content;
    }).toList();

    List<XmlElement> childElements = xmlElement.childElements.toList();
    int index = 1 +
        childElements.lastIndexWhere(
          (element) => element.name.local == "credit-type",
        );

    var firstCreditTextContent = _parseCredit(
      childElements: childElements,
      startFrom: index,
    );

    index = firstCreditTextContent.$1;

    final List<NextCredit> nextCredits = [];
    while (index < childElements.length) {
      var returnValues = _parseCredit(
        childElements: childElements,
        startFrom: index,
      );

      index = returnValues.$1;
      if (returnValues.$2 != null) {
        nextCredits.add(returnValues.$2!);
      }
    }

    return TextCredit(
      value: firstCreditTextContent.$2!.creditText,
      creditTypes: creditTypes,
      nextCredits: nextCredits,
      links: firstCreditTextContent.$2?.links ?? [],
      bookmarks: firstCreditTextContent.$2?.bookmarks ?? [],
      page: Credit._pageFromXml(xmlElement),
      id: xmlElement.getAttribute("id"),
    );
  }
}

class ImageCredit extends Credit {
  final Image value;

  ImageCredit({
    required this.value,
    super.creditTypes = const [],
    super.links = const [],
    super.bookmarks = const [],
    super.page = 1,
    super.id,
  });

  /// not used directly
  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'credit-type': XmlQuantifier.zeroOrMore,
    'link': XmlQuantifier.zeroOrMore,
    'bookmark': XmlQuantifier.zeroOrMore,
    'credit-image': XmlQuantifier.required,
  };

  /// Before using please call [validateSequence] method.
  factory ImageCredit.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);
    Iterable<XmlElement> creditTypeElements = xmlElement.findElements(
      'credit-type',
    );

    List<String> creditTypes = creditTypeElements.map((child) {
      String content = child.innerText;
      if (child.childElements.isNotEmpty) {
        throw XmlElementContentException(
          message: "'credit-type' must have string content",
          xmlElement: child,
        );
      }
      return content;
    }).toList();

    return ImageCredit(
      value: Image.fromXml(xmlElement.getElement('credit-image')!),
      creditTypes: creditTypes,
      links: xmlElement
          .findElements('link')
          .map(
            (e) => Link.fromXml(e),
          )
          .toList(),
      bookmarks: const [],
      page: Credit._pageFromXml(xmlElement),
      id: xmlElement.getAttribute("id"),
    );
  }
}

sealed class CreditText {
  factory CreditText.fromXml(XmlElement xmlElement) {
    return CreditSymbol.fromXml(xmlElement);
  }
}

class CreditSymbol extends FormattedSymbolId implements CreditText {
  CreditSymbol({
    required super.value,
    required super.formatting,
    required super.id,
  });

  factory CreditSymbol.fromXml(XmlElement xmlElement) {
    FormattedSymbolId symbolId = FormattedSymbolId.fromXml(xmlElement);

    return CreditSymbol(
      value: symbolId.value,
      formatting: symbolId.formatting,
      id: symbolId.id,
    );
  }
}

class CreditWords extends FormattedTextId implements CreditText {
  CreditWords({
    required super.value,
    required super.formatting,
    required super.id,
  });

  factory CreditWords.fromXml(XmlElement xmlElement) {
    FormattedTextId formattedTextId = FormattedTextId.fromXml(xmlElement);

    return CreditWords(
      value: formattedTextId.value,
      formatting: formattedTextId.formatting,
      id: formattedTextId.id,
    );
  }
}
