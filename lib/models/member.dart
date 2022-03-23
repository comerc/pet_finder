class MemberModel {
  MemberModel({
    required this.id,
    this.displayName,
    this.imageUrl,
    required this.phone,
    required this.isWhatsApp,
    required this.isViber,
  });

  final String id;
  final String? displayName;
  final String? imageUrl;
  final String phone;
  final bool isWhatsApp;
  final bool isViber;
}
