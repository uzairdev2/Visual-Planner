class Invitation {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final DateTime timestamp;

  Invitation({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.timestamp,
  });

  Invitation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        senderId = json['senderId'],
        senderName = json['senderName'],
        receiverId = json['receiverId'],
        receiverName = json['receiverName'],
        timestamp = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'senderName': senderName,
        'receiverId': receiverId,
        'receiverName': receiverName,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };
}
