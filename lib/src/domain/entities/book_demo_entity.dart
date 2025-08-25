// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookDemoEntity {
  final String? key;
  final String? title;
  final List<String>? author;
  final int? year;
  final String? isbn;
  final String? coverId;
  final bool? tokenAuthenticated;
  final String? apiSource;

  BookDemoEntity({
    this.key,
    this.title,
    this.author,
    this.year,
    this.isbn,
    this.coverId,
    this.tokenAuthenticated,
    this.apiSource,
  });

  // factory BookDemoEntity.fromJson(Map<String, dynamic> json) {
  //   return BookDemoEntity(
  //     key: json['key'] ?? '',
  //     title: json['title'] ?? 'Unknown Title',
  //     author:
  //         json['author_name'] != null ? (json['author_name'] as List?)?.first ?? 'Unknown Author' : 'Unknown Author',
  //     year: json['first_publish_year'] != null ? json['first_publish_year'].toString() : 'Unknown Year',
  //     isbn: json['isbn'] != null ? (json['isbn'] as List?)?.first ?? 'No ISBN' : 'No ISBN',
  //     coverId: json['cover_i']?.toString() ?? '',
  //     tokenAuthenticated: json['token_authenticated'] ?? false,
  //     apiSource: json['api_source'] ?? 'Open Library',
  //   );
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'title': title,
      'author_name': author,
      'first_publish_year': year,
      'isbn': isbn,
      'coverId': coverId,
      'tokenAuthenticated': tokenAuthenticated,
      'apiSource': apiSource,
    };
  }

  factory BookDemoEntity.fromMap(Map<String, dynamic> map) {
    return BookDemoEntity(
      key: map['key'] != null ? map['key'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      author: map['author_name'] != null ? List<String>.from(map['author_name']) : null,
      year: map['first_publish_year'] != null ? map['first_publish_year'] as int : null,
      isbn: map['isbn'] != null ? List<String>.from(map['isbn']).first : null,
      coverId: map['coverId'] != null ? map['coverId'] as String : null,
      tokenAuthenticated: map['tokenAuthenticated'] != null ? map['tokenAuthenticated'] as bool : null,
      apiSource: map['apiSource'] != null ? map['apiSource'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookDemoEntity.fromJson(String source) => BookDemoEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
