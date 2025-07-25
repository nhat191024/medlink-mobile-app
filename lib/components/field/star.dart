import 'package:medlink/utils/app_imports.dart';

class StarReview extends StatelessWidget {
  final ValueChanged<double> onChanged;

  const StarReview({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: 1,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      glow: false,
      unratedColor: AppColors.border,
      itemCount: 5,
      itemSize: 48,
      ratingWidget: RatingWidget(
        full: const Icon(Icons.star_rounded, color: Colors.amber),
        half: const Icon(Icons.star_half_rounded, color: Colors.amber),
        empty: const Icon(Icons.star_border_rounded, color: AppColors.border),
      ),
      onRatingUpdate: onChanged,
    );
  }
}
