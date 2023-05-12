import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String title;
  final String posterImageUrl;
  final String releaseYear;
  final String backgroundImageUrl;
  final List<String> categories;
  final String imdbRating;
  final String duration;
  final String? subtitle;
  final String url;
  final DateTime timestamp;

  Movie({
    required this.title,
    required this.posterImageUrl,
    required this.releaseYear,
    required this.backgroundImageUrl,
    required this.categories,
    required this.imdbRating,
    required this.duration,
    this.subtitle,
    required this.url,
    required this.timestamp,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      posterImageUrl: json['posterImageUrl'] as String,
      releaseYear: json['releaseYear'] as String,
      backgroundImageUrl: json['backgroundImageUrl'] as String,
      categories: json['categories'] is String
          ? [json['categories'] as String]
          : List<String>.from(json['categories'] ?? []),
      imdbRating: (json['imdbRating'] as String),
      subtitle:
          json.containsKey('subtitle') ? (json['subtitle'] as String) : null,
      duration: (json['duration'] as String),
      url: json['url'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'posterImageUrl': posterImageUrl,
      'releaseYear': releaseYear,
      'backgroundImageUrl': backgroundImageUrl,
      'categories': categories,
      'imdbRating': imdbRating,
      'duration': duration,
      'subtitle': subtitle,
      'url': url,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
