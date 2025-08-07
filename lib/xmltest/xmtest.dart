import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

Future<void> fetchAndFilterDisasters() async {
  final url = 'https://www.gdacs.org/xml/rss.xml';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final document = xml.XmlDocument.parse(response.body);

    final items = document.findAllElements('item');

    // Filter by country (e.g., Myanmar)
    final filtered =
        items.where((item) {
          final country = item.getElement('gdacs:country')?.text ?? '';
          return country.contains('Myanmar');
        }).toList();

    if (filtered.isEmpty) {
      print("empty");
    }
    // Print filtered titles
    for (var item in filtered) {
      final title = item.getElement('title')?.text;
      final link = item.getElement('link')?.text;
      print('Disaster: $title');
      print('More info: $link\n');
    }
  } else {
    print('Failed to fetch RSS: ${response.statusCode}');
  }
}

void main() async {
  await fetchAndFilterDisasters();
}
