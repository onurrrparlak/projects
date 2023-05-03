class Movie {
  final String title;
  final String posterImageUrl;
  final String releaseYear;
  final String backgroundImageUrl;
  final String categories;
  final String imdbRating;
  final String duration;
  final String url;

  Movie({
    required this.title,
    required this.posterImageUrl,
    required this.releaseYear,
    required this.backgroundImageUrl,
    required this.categories,
    required this.imdbRating,
    required this.duration,
    required this.url,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      posterImageUrl: json['posterImageUrl'] as String,
      releaseYear: json['releaseYear'] as String,
      backgroundImageUrl: json['backgroundImageUrl'] as String,
      categories: (json['categories'] as String),
      imdbRating: (json['imdbRating'] as String),
      duration: (json['duration'] as String),
      url: json['url'] as String,
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
      'url': url,
    };
  }
}
