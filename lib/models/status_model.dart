class Status {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> photoUrlList;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSeeStatus;
  Status({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.photoUrlList,
    required this.createdAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSeeStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrlList,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSeeStatus,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrlList: List<String>.from(map['photoUrl']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      profilePic: map['profilePic'] ?? '',
      statusId: map['statusId'] ?? '',
      whoCanSeeStatus: List<String>.from(map['whoCanSee']),
    );
  }
}
