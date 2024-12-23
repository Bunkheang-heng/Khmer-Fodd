import 'package:flutter/material.dart';

class RecipeFilters extends StatefulWidget {
  final TextEditingController searchController;
  final String? selectedTimeFilter;
  final double? selectedRating;
  final String? selectedTag;
  final List<String> availableTags;
  final Function(String) onSearchChanged;
  final Function(String?) onTimeFilterSelected;
  final Function(double?) onRatingSelected;
  final Function(String?) onTagSelected;

  const RecipeFilters({
    super.key,
    required this.searchController,
    this.selectedTimeFilter,
    this.selectedRating,
    this.selectedTag,
    required this.availableTags,
    required this.onSearchChanged,
    required this.onTimeFilterSelected,
    required this.onRatingSelected,
    required this.onTagSelected,
  });

  @override
  State<RecipeFilters> createState() => _RecipeFiltersState();
}

class _RecipeFiltersState extends State<RecipeFilters> {
  String? _tempTimeFilter;
  double? _tempRating;
  String? _tempTag;

  @override
  void initState() {
    super.initState();
    _tempTimeFilter = widget.selectedTimeFilter;
    _tempRating = widget.selectedRating;
    _tempTag = widget.selectedTag;
  }

  void _applyFilters() {
    widget.onTimeFilterSelected(_tempTimeFilter);
    widget.onRatingSelected(_tempRating);
    widget.onTagSelected(_tempTag);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _tempTimeFilter = null;
      _tempRating = null;
      _tempTag = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ស្វែងរកតាមការចម្រាញ់',
                style: TextStyle(
                  fontFamily: 'Chenla',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _resetFilters,
                child: const Text(
                  'កំណត់ឡើងវិញ',
                  style: TextStyle(fontFamily: 'Chenla'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Time Filter Section
          const Text(
            'ពេលវេលា',
            style: TextStyle(
              fontFamily: 'Chenla',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTimeFilterChip('ថ្មីបំផុត'),
                _buildTimeFilterChip('ចាស់បំផុត'),
                _buildTimeFilterChip('កំពុងពេញនិយម'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Rating Filter Section
          const Text(
            'ការវាយតម្លៃ',
            style: TextStyle(
              fontFamily: 'Chenla',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 5; i >= 1; i--) _buildRatingChip(i.toDouble()),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tags Filter Section
          const Text(
            'ស្លាក',
            style: TextStyle(
              fontFamily: 'Chenla',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTagChip('ទាំងអស់'),
              ...widget.availableTags.map((tag) => _buildTagChip(tag)),
            ],
          ),

          const SizedBox(height: 20),

          // Apply Filter Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'អនុវត្តការចម្រាញ់',
                style: TextStyle(
                  fontFamily: 'Chenla',
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilterChip(String label) {
    bool isSelected = _tempTimeFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontFamily: 'Chenla',
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _tempTimeFilter = selected ? label : null;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingChip(double rating) {
    bool isSelected = _tempRating == rating;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              rating.toStringAsFixed(0),
              style: TextStyle(
                fontFamily: 'Chenla',
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.star,
              size: 16,
              color: isSelected ? Colors.white : Colors.amber,
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _tempRating = selected ? rating : null;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    bool isSelected = _tempTag == tag;
    return FilterChip(
      label: Text(
        tag,
        style: TextStyle(
          fontFamily: 'Chenla',
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _tempTag = selected ? tag : null;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
    );
  }
}
