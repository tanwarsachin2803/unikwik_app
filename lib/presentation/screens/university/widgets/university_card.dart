import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:unikwik_app/presentation/widgets/glass_container.dart';

String getUniversityInitials(String name) {
  final words = name.split(' ');
  if (words.length == 1) return words[0].substring(0, 2).toUpperCase();
  return (words[0][0] + words[1][0]).toUpperCase();
}

class UniversityCard extends StatelessWidget {
  final Map<String, dynamic> university;
  final int index;
  final bool isExpanded;
  final VoidCallback? onTap;

  const UniversityCard({
    super.key,
    required this.university,
    required this.index,
    required this.isExpanded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = university['name'] as String;
    final country = university['country'] as String;
    final rank = university['rank'] is num ? (university['rank'] as num).toInt() : int.tryParse(university['rank'].toString()) ?? 0;
    final score = university['score'] is num ? (university['score'] as num).toDouble() : double.tryParse(university['score'].toString()) ?? 0.0;
    final tuitionFee = university['tuitionFee'] is num ? (university['tuitionFee'] as num).toInt() : int.tryParse(university['tuitionFee'].toString()) ?? 0;
    final applicationFee = university['applicationFee'] is num ? (university['applicationFee'] as num).toInt() : int.tryParse(university['applicationFee'].toString()) ?? 0;
    final applicationOpen = university['applicationOpen'] ?? false;
    final region = university['region'] as String;
    final flag = university['flag'] ?? '🏳️';
    final isWatchlisted = university['isWatchlisted'] as bool? ?? false;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: GlassContainer(
        child: Container(
            padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: applicationOpen 
                    ? Colors.green.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
                width: applicationOpen ? 2 : 1,
              ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // Header row with ranking, name, and watchlist
                    Row(
                      children: [
                    // Ranking badge
                            Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber[400]!,
                            Colors.amber[600]!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                              ),
                        ],
                      ),
                                child: Text(
                        '#$rank',
                        style: const TextStyle(
                          color: Colors.white,
                                    fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Score badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 1,
                        ),
                                  ),
                      child: Text(
                        '${score.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                                ),
                              ),
                            ),
                    const Spacer(),
                    // Watchlist button
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement watchlist toggle
                      },
                                child: Container(
                        padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                          color: isWatchlisted 
                              ? Colors.red.withOpacity(0.2)
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isWatchlisted 
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isWatchlisted 
                              ? Colors.red[300]
                              : Colors.white.withOpacity(0.7),
                          size: 20,
                        ),
                                    ),
                                  ),
                  ],
                ),
                const SizedBox(height: 16),
                // University name
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Country and region info
                Row(
                  children: [
                    Text(
                      flag,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                                  child: Text(
                        country,
                                    style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        region,
                        style: TextStyle(
                          color: Colors.purple[300],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                            children: [
                      const SizedBox(height: 16),
                      // Financial info
                              Row(
                                children: [
                                  Expanded(
                            child: _buildInfoChip(
                              icon: Icons.attach_money_rounded,
                              label: 'Tuition',
                              value: '\$${tuitionFee.toStringAsFixed(0)}',
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoChip(
                              icon: Icons.description_rounded,
                              label: 'App Fee',
                              value: '\$${applicationFee.toStringAsFixed(0)}',
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Application status
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: applicationOpen 
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: applicationOpen 
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.red.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  applicationOpen 
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  color: applicationOpen 
                                      ? Colors.green[300]
                                      : Colors.red[300],
                                  size: 16,
                                  ),
                                const SizedBox(width: 6),
                                Text(
                                  applicationOpen ? 'Open' : 'Closed',
                                  style: TextStyle(
                                    color: applicationOpen 
                                        ? Colors.green[300]
                                        : Colors.red[300],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Apply button
                                  GestureDetector(
                            onTap: () {
                              // TODO: Implement apply functionality
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue[400]!,
                                    Colors.blue[600]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Apply',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                    ),
                                  ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
              Icon(
                icon,
                color: color,
                size: 16,
                              ),
              const SizedBox(width: 6),
                            Text(
                label,
                              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
              ),
            ],
      ),
    );
  }
}