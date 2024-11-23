import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:shimmer/shimmer.dart';

class TechNewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.article, size: 30),
            SizedBox(width: 10),
            Text(
              'Tech News',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('news')
                  .orderBy('created_at', descending: true) // Order by latest news
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerLoader(); // Display shimmer animation
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error loading news.'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No news available.'));
                }

                final newsList = snapshot.data!.docs.map((doc) {
                  return News(
                    image: doc['image'], // Assuming 'image' is a URL
                    title: doc['title'],
                    summary: doc['summary'],
                    source: doc['source'],
                    url: doc['url'],
                    postedAt: (doc['created_at'] as Timestamp).toDate(),
                  );
                }).toList();

                return PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: newsList.length,
                  controller: PageController(viewportFraction: 0.8, initialPage: 0),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: NewsCard(news: newsList[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Shimmer loader
  Widget _buildShimmerLoader() {
    return ListView.builder(
      itemCount: 6, // Number of shimmer placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 250, // Approximate height of a news card
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.network(
              news.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  news.summary,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      news.source,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueAccent,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await EasyLauncher.url(
                          url: news.url,
                          mode: Mode.inAppBrowser,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Read More',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class News {
  final String image;
  final String title;
  final String summary;
  final String source;
  final String url;
  final DateTime postedAt;

  News({
    required this.image,
    required this.title,
    required this.summary,
    required this.source,
    required this.url,
    required this.postedAt,
  });
}
