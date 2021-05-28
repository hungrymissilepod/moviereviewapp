import 'package:flutter/material.dart';

/// Utilities
import 'package:moviereviewapp/utilities/size_config.dart';

class StarRow extends StatelessWidget {
    
  StarRow(this.voteAverage, { this.showHalfStars = false });
  final double voteAverage;
  final bool showHalfStars;
  
  @override
  Widget build(BuildContext context) {
    double stars = voteAverage / 2; /// convert vote score to number of stars
    return Row(
      children: List.generate(5, (index) {
        IconData icon = Icons.star_outline_rounded; /// default to empty star

        /// If we want to show half stars we have to calculate stars in a different way
        if (showHalfStars) {
          if (stars > index + 1) { icon = Icons.star_rounded; }
          else if (stars > index && (stars - index) >= 0.5) { icon = Icons.star_half_rounded; }
        } else {
          if (stars > index) { icon = Icons.star_rounded; }
        }
        return Icon(icon, size: SizeConfig.blockSizeVertical * 3);
      }),
    );
  }
}