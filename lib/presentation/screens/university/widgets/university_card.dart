import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/data/models/university_model.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';

String getUniversityInitials(String name) {
  final words = name.split(' ');
  if (words.length == 1) return words[0].substring(0, 2).toUpperCase();
  return (words[0][0] + words[1][0]).toUpperCase();
}

class UniversityCard extends StatelessWidget {
  final University university;
  final int index;
  final VoidCallback? onWatchlistToggle;
  const UniversityCard({super.key, required this.university, required this.index, this.onWatchlistToggle});

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.95;
    final ranking = university.effectiveRanking; // Use effective ranking from CSV
    final bool isOpen = university.csvRanking?.isCurrentlyOpen ?? false;

    // Decrease the image and font sizes by 20%
    const double imageSize = 80 * 0.8; // 64
    const double iconSize = 40 * 0.8; // 32
    const double rankingFontSize = 16 * 0.8; // 12.8
    const double nameFontSize = 20 * 0.8; // 16
    const double countryFontSize = 16 * 0.8; // 12.8
    const double tuitionFontSize = 16 * 0.8; // 12.8
    const double appFontSize = 16 * 0.8; // 12.8
    const double emojiFontSize = 16 * 0.8; // 12.8
    const double heartIconSize = 28 * 0.8; // 22.4

    // Decrease the vertical margin (gap between cards) by 50%
    const double verticalMargin = 8 * 0.5; // 4

    // Decrease paddings and spacings by 20%
    const double containerPadding = 16 * 0.8; // 12.8
    const double imageTextSpacing = 16 * 0.8; // 12.8
    const double nameCountrySpacing = 4 * 0.8; // 3.2
    const double countryTuitionSpacing = 8 * 0.8; // 6.4
    const double rowSpacing = 12 * 0.8; // 9.6
    const double emojiSpacing = 16 * 0.8; // 12.8

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.symmetric(vertical: verticalMargin, horizontal: 0),
        clipBehavior: Clip.none, // Prevent clipping of shadow
        decoration: isOpen
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.95),
                    blurRadius: 48,
                    spreadRadius: 10,
                  ),
                ],
              )
            : null,
        child: Container(
          width: cardWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.black.withOpacity(0.18),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            color: Colors.white.withOpacity(0.18),
          ),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(containerPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // University initials with ranking badge overlay
                        Stack(
                          children: [
                            Container(
                              width: imageSize,
                              height: imageSize,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.blue, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  getUniversityInitials(university.name),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            if (ranking != null && ranking > 0)
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD700), // Golden shade
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                  child: Text(
                                    ranking.toString(), // No hashtag
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: rankingFontSize,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: imageTextSpacing),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      university.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: nameFontSize,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: onWatchlistToggle,
                                    child: Icon(
                                      university.isWatchlisted ? Icons.favorite : Icons.favorite_border,
                                      color: university.isWatchlisted ? Colors.redAccent : Colors.white,
                                      size: heartIconSize,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: nameCountrySpacing),
                              Text(
                                university.country,
                                style: TextStyle(
                                  fontSize: countryFontSize,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: countryTuitionSpacing),
                              Row(
                                children: [
                                  Text(
                                    'Tuition: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: tuitionFontSize,
                                    ),
                                  ),
                                  Text(
                                    '\$${university.tuitionFee.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontSize: tuitionFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'App: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: appFontSize,
                              ),
                            ),
                            Text(
                              '\$${university.applicationFee.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: appFontSize,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: rowSpacing),
                        Text('🌞 Sep', style: TextStyle(fontSize: emojiFontSize, color: Colors.white)),
                        SizedBox(width: emojiSpacing),
                        Text('❄️ Jan', style: TextStyle(fontSize: emojiFontSize, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ).asGlass(
                enabled: true,
                tintColor: AppColors.deepTeal.withOpacity(0.85),
                clipBorderRadius: BorderRadius.circular(24),
                blurX: 6,
                blurY: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}