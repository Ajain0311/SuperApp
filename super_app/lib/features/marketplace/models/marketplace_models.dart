class MarketplaceCategory {
  final int id;
  final String name;
  final String? iconUrl;
  final int listingCount;

  const MarketplaceCategory({
    required this.id,
    required this.name,
    this.iconUrl,
    this.listingCount = 0,
  });

  factory MarketplaceCategory.fromJson(Map<String, dynamic> json) {
    return MarketplaceCategory(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      iconUrl: json['iconUrl'] as String?,
      listingCount: json['listingCount'] as int? ?? 0,
    );
  }
}

class ListingSummary {
  final int id;
  final String title;
  final double price;
  final String condition;
  final String? location;
  final String? primaryImageUrl;
  final bool isFeatured;
  final int viewCount;
  final String status;
  final DateTime createdAt;
  final int categoryId;
  final String categoryName;
  final bool isFavorite;

  const ListingSummary({
    required this.id,
    required this.title,
    required this.price,
    required this.condition,
    this.location,
    this.primaryImageUrl,
    this.isFeatured = false,
    this.viewCount = 0,
    this.status = 'ACTIVE',
    required this.createdAt,
    required this.categoryId,
    required this.categoryName,
    this.isFavorite = false,
  });

  ListingSummary copyWith({
    bool? isFavorite,
    int? viewCount,
    String? status,
  }) {
    return ListingSummary(
      id: id,
      title: title,
      price: price,
      condition: condition,
      location: location,
      primaryImageUrl: primaryImageUrl,
      isFeatured: isFeatured,
      viewCount: viewCount ?? this.viewCount,
      status: status ?? this.status,
      createdAt: createdAt,
      categoryId: categoryId,
      categoryName: categoryName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory ListingSummary.fromJson(Map<String, dynamic> json) {
    return ListingSummary(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      condition: json['condition'] as String? ?? 'USED',
      location: json['location'] as String?,
      primaryImageUrl: json['primaryImageUrl'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
      viewCount: json['viewCount'] as int? ?? 0,
      status: json['status'] as String? ?? 'ACTIVE',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      categoryId: json['categoryId'] as int? ?? 0,
      categoryName: json['categoryName'] as String? ?? 'General',
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}

class ListingDetail {
  final int id;
  final String title;
  final String? description;
  final double price;
  final String condition;
  final String? location;
  final String status;
  final bool isFeatured;
  final int viewCount;
  final DateTime createdAt;
  final int categoryId;
  final String categoryName;
  final int sellerId;
  final String sellerName;
  final String? sellerPhone;
  final String? sellerAvatar;
  final DateTime? sellerJoinedAt;
  final bool isFavorite;
  final List<String> images;

  const ListingDetail({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    required this.condition,
    this.location,
    this.status = 'ACTIVE',
    this.isFeatured = false,
    this.viewCount = 0,
    required this.createdAt,
    required this.categoryId,
    required this.categoryName,
    required this.sellerId,
    required this.sellerName,
    this.sellerPhone,
    this.sellerAvatar,
    this.sellerJoinedAt,
    this.isFavorite = false,
    required this.images,
  });

  factory ListingDetail.fromJson(Map<String, dynamic> json) {
    return ListingDetail(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      condition: json['condition'] as String? ?? 'USED',
      location: json['location'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
      isFeatured: json['isFeatured'] as bool? ?? false,
      viewCount: json['viewCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      categoryId: json['categoryId'] as int? ?? 0,
      categoryName: json['categoryName'] as String? ?? 'General',
      sellerId: json['sellerId'] as int? ?? 1,
      sellerName: json['sellerName'] as String? ?? 'Seller',
      sellerPhone: json['sellerPhone'] as String?,
      sellerAvatar: json['sellerAvatar'] as String?,
      sellerJoinedAt: json['sellerJoinedAt'] != null
          ? DateTime.tryParse(json['sellerJoinedAt'] as String)
          : null,
      isFavorite: json['isFavorite'] as bool? ?? false,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
