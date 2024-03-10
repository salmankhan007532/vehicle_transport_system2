class Rating {
  late String ratingId;
  late String seekerId;
  late num value;

  Rating({required this.ratingId, required this.seekerId, required this.value});

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      ratingId: map['ratingId'],
      seekerId: map['seekerId'],
      value: map['value'],
    );
  }
}
