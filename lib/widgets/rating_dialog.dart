import 'package:flutter/material.dart';

class RatingDialog extends StatefulWidget {
  final double initialRating;

  const RatingDialog({
    Key? key,
    required this.initialRating,
  }) : super(key: key);

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late double _rating;
  bool _isHovering = false;
  double _hoverRating = 0;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  Widget _buildStar(int index) {
    final starValue = index + 1;
    final isHalfStar = (_rating - index) > 0 && (_rating - index) < 1;
    final isFilled = (_isHovering ? _hoverRating : _rating) >= starValue;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isHovering = true;
          _hoverRating = starValue.toDouble();
        });
      },
      onTapUp: (_) {
        setState(() {
          _rating = starValue.toDouble();
          _isHovering = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isHovering = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(
          isHalfStar
              ? Icons.star_half
              : isFilled
                  ? Icons.star
                  : Icons.star_border,
          color: Colors.amber,
          size: 36,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'វាយតម្លៃមុខម្ហូប',
        style: TextStyle(
          fontFamily: 'Chenla',
          fontSize: 24,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => _buildStar(index)),
          ),
          const SizedBox(height: 16),
          Text(
            'ពិន្ទុ: ${_rating.toStringAsFixed(1)}',
            style: const TextStyle(
              fontFamily: 'Chenla',
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'បោះបង់',
            style: TextStyle(
              fontFamily: 'Chenla',
              color: Colors.grey,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _rating),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text(
            'វាយតម្លៃ',
            style: TextStyle(
              fontFamily: 'Chenla',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
