import 'package:flutter/material.dart';
import 'package:super_app/core/theme/app_colors.dart';
import 'package:super_app/core/theme/app_text_styles.dart';
import 'package:super_app/features/marketplace/models/marketplace_models.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController(text: 'Koramangala, Bengaluru');
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  int _selectedCategoryId = 1;
  String _selectedCondition = 'LIKE_NEW';
  bool _isLoading = false;

  final List<String> _photos = [
    'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600',
  ];

  final List<Map<String, dynamic>> _categories = const [
    {'id': 1, 'name': 'Mobiles'},
    {'id': 2, 'name': 'Vehicles'},
    {'id': 3, 'name': 'Electronics'},
    {'id': 4, 'name': 'Furniture'},
    {'id': 5, 'name': 'Fashion'},
    {'id': 6, 'name': 'Books'},
    {'id': 7, 'name': 'Sports'},
    {'id': 8, 'name': 'Others'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _addPhotoUrl() {
    final url = _imageUrlController.text.trim();
    if (url.isNotEmpty) {
      setState(() {
        _photos.add(url);
        _imageUrlController.clear();
      });
    }
  }

  void _submitListing() async {
    if (!_formKey.currentState!.validate()) return;
    if (_photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one photo of the item')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    final cat = _categories.firstWhere((c) => c['id'] == _selectedCategoryId, orElse: () => _categories.first);

    final newListing = ListingSummary(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0,
      condition: _selectedCondition,
      location: _locationController.text.trim(),
      primaryImageUrl: _photos.first,
      isFeatured: false,
      viewCount: 1,
      createdAt: DateTime.now(),
      categoryId: _selectedCategoryId,
      categoryName: cat['name'] as String,
      isFavorite: false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your Ad has been published to Community Bazaar! 🎉'),
        backgroundColor: AppColors.secondary,
      ),
    );

    Navigator.pop(context, newListing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Post an Item for Sale', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Upload Section
              Text('Photos (Upload up to 5)', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              Text('Clear photos with good lighting attract 3x more buyers.', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Add Photo Box
                    GestureDetector(
                      onTap: () {
                        _showAddPhotoDialog();
                      },
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary, style: BorderStyle.solid),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 28),
                            SizedBox(height: 4),
                            Text('Add Photo', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Photo Thumbnails
                    ...List.generate(_photos.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _photos[index],
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 90,
                                  height: 90,
                                  color: AppColors.surfaceLight,
                                  child: const Icon(Icons.broken_image, color: AppColors.textTertiary),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _photos.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.black87,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                            if (index == 0)
                              Positioned(
                                bottom: 4,
                                left: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('COVER', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Category Picker
              Text('Category', style: AppTextStyles.h3),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedCategoryId,
                    isExpanded: true,
                    dropdownColor: AppColors.cardDark,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    items: _categories.map((c) {
                      return DropdownMenuItem<int>(
                        value: c['id'] as int,
                        child: Text(c['name'] as String),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCategoryId = val;
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title Field
              Text('Item Title', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('e.g. Apple MacBook Air M2 16GB 512GB'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Title is required';
                  if (val.trim().length < 5) return 'Title must be at least 5 characters';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Price Field
              Text('Price', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                decoration: _inputDecoration('e.g. 75000').copyWith(
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Price is required';
                  final p = double.tryParse(val.trim());
                  if (p == null || p <= 0) return 'Enter a valid price';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Condition Selector
              Text('Condition', style: AppTextStyles.h3),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildConditionOption('NEW', 'Brand New'),
                  const SizedBox(width: 8),
                  _buildConditionOption('LIKE_NEW', 'Like New'),
                  const SizedBox(width: 8),
                  _buildConditionOption('USED', 'Used'),
                ],
              ),

              const SizedBox(height: 20),

              // Location Field
              Text('Location', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Area, City (e.g. Indiranagar, Bengaluru)').copyWith(
                  prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.textTertiary),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Location is required' : null,
              ),

              const SizedBox(height: 20),

              // Description Field
              Text('Description & Details', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Mention usage duration, warranty status, accessories included, reason for selling...'),
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitListing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'Post My Ad Now',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionOption(String value, String label) {
    final isSelected = _selectedCondition == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCondition = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surfaceLight,
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  void _showAddPhotoDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Photo', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _imageUrlController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Paste image URL here...'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Or choose a sample asset:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Text('MacBook'),
                    onPressed: () {
                      _imageUrlController.text = 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600';
                    },
                  ),
                  ActionChip(
                    label: const Text('Camera'),
                    onPressed: () {
                      _imageUrlController.text = 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600';
                    },
                  ),
                  ActionChip(
                    label: const Text('Guitar'),
                    onPressed: () {
                      _imageUrlController.text = 'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=600';
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                _addPhotoUrl();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Add Photo'),
            ),
          ],
        );
      },
    );
  }
}
