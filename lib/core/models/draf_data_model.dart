class DrafDataModel {
  final int? id;
  final String address;
  final double latitude;
  final double longitude;
  final String? time;

  DrafDataModel({
    this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.time,
  });

  // Convert DrafDataModel object to a map for storing in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'time': time,
    };
  }

  // Convert a map to a DrafDataModel object (from the database)
  factory DrafDataModel.fromMap(Map<String, dynamic> map) {
    return DrafDataModel(
      id: map['id'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      time: map['time'],
    );
  }
}
