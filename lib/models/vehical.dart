class Vehical {
  late String vehicalId;
  late String vehicalNum;
  late String vehicalName;
  late String ownerName;
  late String ownerId;
  late String contactNum;
  late String availableSeats;
  late String seatRent;
  late String facilities;
  late String totalseats;
  late List<Object?> photos;
  late double latitude;
  late double longitude;

  Vehical({
    required this.vehicalId,
    required this.vehicalNum,
    required this.vehicalName,
    required this.ownerName,
    required this.ownerId,
    required this.contactNum,
    required this.availableSeats,
    required this.seatRent,
    required this.facilities,
    required this.totalseats,
    required this.photos,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'vehicallId': vehicalId,
      'vehicalNum': vehicalNum,
      'VehicalName': vehicalName,
      'ownerName': ownerName,
      'ownerId': ownerId,
      'contactNum': contactNum,
      'availableSeats': availableSeats,
      'seatRent': seatRent,
      'facilities': facilities,
      'totalSeats': totalseats,
      'photos': photos,
      'latitude': latitude,
      'longitude': longitude,
    };

    return map;
  }

  factory Vehical.fromMap(Map<String, dynamic> map) {
    return Vehical(
      vehicalId: map['vehicallId'],
      vehicalNum: map['vehicalNum'],
      vehicalName: map['VehicalName'],
      ownerName: map['ownerName'],
      ownerId: map['ownerId'],
      contactNum: map['contactNum'],
      availableSeats: map['availableSeats'],
      seatRent: map['seatRent'],
      facilities: map['facilities'],
      totalseats: map['totalSeats'],
      photos: map['photos'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
