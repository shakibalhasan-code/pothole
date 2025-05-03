class PotholeModel {
  final String id;
  final String issue;
  final String severityLevel;
  final String description;
  final String user; // User ID
  final String status;
  final Location location;
  final List<String> images;
  final List<String> videos;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> verifiedBy; // List of user IDs

  PotholeModel({
    required this.id,
    required this.issue,
    required this.severityLevel,
    required this.description,
    required this.user,
    required this.status,
    required this.location,
    required this.images,
    required this.videos,
    required this.createdAt,
    required this.updatedAt,
    required this.verifiedBy,
  });

  factory PotholeModel.fromJson(Map<String, dynamic> json) {
    // Helper function to parse lists of strings, handling nulls
    List<String> parseStringList(dynamic listJson) {
      if (listJson == null) return [];
      if (listJson is List) {
        return listJson.map((item) => item.toString()).toList();
      }
      return []; // Return empty list if format is unexpected
    }

    return PotholeModel(
      // Map '_id' from JSON to 'id' in your model
      id: json['_id'] as String,
      issue: json['issue'] as String? ?? 'Unknown Issue', // Add null checks
      severityLevel: json['severityLevel'] as String? ?? 'Unknown Severity',
      description: json['description'] as String? ?? 'No description provided.',
      user: json['user'] as String? ?? 'Unknown User',
      status: json['status'] as String? ?? 'Unknown Status',
      location: Location.fromJson(
        json['location'] as Map<String, dynamic>? ?? {},
      ), // Handle potential null location
      images: parseStringList(json['images']),
      videos: parseStringList(json['videos']),
      // Parse dates, handle potential errors or nulls
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      verifiedBy: parseStringList(json['verifiedBy']),
    );
  }
}

// --- You need to define the Location class ---
class Location {
  final String address;
  final double latitude;
  final double longitude;

  Location({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'] as String? ?? 'Unknown Address', // Handle null
      latitude:
          (json['latitude'] as num? ?? 0.0)
              .toDouble(), // Handle null and ensure double
      longitude:
          (json['longitude'] as num? ?? 0.0)
              .toDouble(), // Handle null and ensure double
    );
  }
}
