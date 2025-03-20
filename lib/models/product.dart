class Product {
  final String documentId;
  final int idsp;
  final String ten;
  final String loaisp;
  final int gia;
  final String hinhanh;

  Product({
    required this.documentId,
    required this.idsp,
    required this.ten,
    required this.loaisp,
    required this.gia,
    required this.hinhanh,
  });

  // Factory constructor to map Firestore data to Product object
  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      documentId: documentId,
      idsp: data['idsp'],
      ten: data['ten'] ?? 'No Name',
      loaisp: data['loaisp'] ?? 'Unknown',
      gia: data['gia'] as int,
      hinhanh: data['hinhanh'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "idsp": idsp,
       "ten":ten,
      "loaisp": loaisp,
      "gia": gia,
      "hinhanh": hinhanh,
    };
  }
}
