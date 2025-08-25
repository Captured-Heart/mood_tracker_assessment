class BadgeEntity {
  final num threshold;
  final String title;
  final String description;
  final String? earnedAt;

  const BadgeEntity({required this.threshold, required this.title, required this.description, this.earnedAt});
}

class EarnedBadge {
  final BadgeEntity badge;
  final DateTime earnedAt;

  EarnedBadge({required this.badge, required this.earnedAt});
}

// class Badge {
//   final String id;
//   final BadgeType type;
//   final String title;
//   final String description;
//   final DateTime earnedAt;

//   Badge({
//     required this.id,
//     required this.type,
//     required this.title,
//     required this.description,
//     required this.earnedAt,
//   });

//   factory Badge.fromJson(Map<String, dynamic> json) {
//     return Badge(
//       id: json['id'],
//       type: BadgeType.values.firstWhere((e) => e.toString() == json['type']),
//       title: json['title'],
//       description: json['description'],
//       earnedAt: DateTime.parse(json['earnedAt']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'type': type.toString(),
//       'title': title,
//       'description': description,
//       'earnedAt': earnedAt.toIso8601String(),
//     };
//   }
// }

// class UserStats {
//   final String userId;
//   final int totalEntries;
//   final int points;
//   final List<Badge> badges;
//   final int currentStreak;
//   final DateTime lastEntryDate;

//   UserStats({
//     required this.userId,
//     required this.totalEntries,
//     required this.points,
//     required this.badges,
//     required this.currentStreak,
//     required this.lastEntryDate,
//   });

//   factory UserStats.fromJson(Map<String, dynamic> json) {
//     return UserStats(
//       userId: json['userId'],
//       totalEntries: json['totalEntries'],
//       points: json['points'],
//       badges: (json['badges'] as List).map((badge) => Badge.fromJson(badge)).toList(),
//       currentStreak: json['currentStreak'],
//       lastEntryDate: DateTime.parse(json['lastEntryDate']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'totalEntries': totalEntries,
//       'points': points,
//       'badges': badges.map((badge) => badge.toJson()).toList(),
//       'currentStreak': currentStreak,
//       'lastEntryDate': lastEntryDate.toIso8601String(),
//     };
//   }
// }
