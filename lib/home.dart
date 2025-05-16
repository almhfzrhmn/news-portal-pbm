import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail.dart';

// Constants
const _kNewsApiUrl = 'https://newsapi.org/v2/top-headlines';
const _kApiKey = 'bb0a23b05c6443d5994ca378068e2393'; // TODO: Move to .env
const _kDefaultImageUrl =
    'https://mgmall.s3.amazonaws.com/img/062023/390bed03e54f6440416f0568f61a82b563176996.jpg';
const _kCardBorder = BorderSide(color: Colors.blue, width: 3.0);
const _kCardBorderRadius = BorderRadius.all(Radius.circular(10.0));
const _kCardPadding = EdgeInsets.all(8.0);
const _kCardMargin = EdgeInsets.only(bottom: 16.0);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> getData() async {
    try {
      final response = await http.get(
        Uri.parse('$_kNewsApiUrl?sources=techcrunch&apiKey=$_kApiKey'),
      );
      print("response hit api : $response[] ");
      if (response.statusCode == 200) {
        return json.decode(response.body)['articles'] ?? [];
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Widget _newsCard({
    required String datetime,
    required String title,
    required String? description,
    required String? imageUrl,
    required Key key,
  }) {
    return GestureDetector(
      key: key,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DetailPage(
                  judul: title,
                  content: description ?? 'No description available',
                  datetime: datetime,
                  image: imageUrl ?? _kDefaultImageUrl,
                ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: _kCardBorderRadius),
        margin: _kCardMargin,
        child: Padding(
          padding: _kCardPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl ?? _kDefaultImageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Image.network(
                          _kDefaultImageUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      datetime,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      description ?? 'No description available',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Berita'),
        key: const Key('homeAppBar'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => setState(() {}), // Retry
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news available'));
          }
          return ListView.builder(
            key: const Key('newsList'),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              final article = snapshot.data![i];
              return _newsCard(
                key: Key('newsCard_$i'),
                datetime: article['publishedAt'] ?? 'Unknown date',
                title: article['title'] ?? 'No title',
                description: article['description'],
                imageUrl: article['urlToImage'],
              );
            },
          );
        },
      ),
    );
  }
}
