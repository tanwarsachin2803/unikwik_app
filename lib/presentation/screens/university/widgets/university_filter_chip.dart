import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

class RegionOption {
  final String label;
  final String assetPath;

  const RegionOption({required this.label, required this.assetPath});
}

class UniversityFilterChip extends StatefulWidget {
  final String? selectedRegion;
  final ValueChanged<String?>? onRegionSelected;
  final double iconSize;
  const UniversityFilterChip({super.key, this.selectedRegion, this.onRegionSelected, this.iconSize = 20});

  @override
  State<UniversityFilterChip> createState() => _UniversityFilterChipState();
}

class _UniversityFilterChipState extends State<UniversityFilterChip> {
  static const List<RegionOption> _regions = [
    RegionOption(label: 'Region', assetPath: 'lib/screens/universities/assets/regions/world.png'),
    RegionOption(label: 'World', assetPath: 'lib/screens/universities/assets/regions/world.png'),
    RegionOption(label: 'Europe', assetPath: 'lib/screens/universities/assets/regions/europe.png'),
    RegionOption(label: 'North America', assetPath: 'lib/screens/universities/assets/regions/na.png'),
    RegionOption(label: 'Asia', assetPath: 'lib/screens/universities/assets/regions/asia.png'),
    RegionOption(label: 'Africa', assetPath: 'lib/screens/universities/assets/regions/africa.png'),
    RegionOption(label: 'South America', assetPath: 'lib/screens/universities/assets/regions/sa.png'),
    RegionOption(label: 'Oceania', assetPath: 'lib/screens/universities/assets/regions/oceania.png'),
  ];

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _dropdownOverlay;

  String? _selectedRegionLabel;

  bool get _dropdownOpen => _dropdownOverlay != null;

  @override
  void initState() {
    super.initState();
    // Initialize with widget.selectedRegion if provided, else null (shows placeholder)
    _selectedRegionLabel = widget.selectedRegion;
  }

  void _showDropdown() {
    if (_dropdownOverlay != null) return;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    // Use the calculated max width for the dropdown
    final double dropdownWidth = _regions
        .map((r) => _calculateChipWidth(context, r.label))
        .reduce((a, b) => a > b ? a : b);

    _dropdownOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // This GestureDetector covers the whole screen and closes the dropdown when tapped
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _hideDropdown();
                  setState(() {});
                },
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy + renderBox.size.height + 8,
              width: dropdownWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, 0),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        // Glass effect for dropdown
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: _regions
                              .where((region) => region.label != 'Region')
                              .map((region) {
                            return InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                _onSelect(region);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Show the full region label, never ellipsis, never wrap
                                    Text(
                                      region.label,
                                      style: const TextStyle(fontSize: 16, color: Colors.white),
                                      overflow: TextOverflow.clip,
                                      softWrap: false,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ).asGlass(
                          tintColor: Colors.white.withOpacity(0.15),
                          blurX: 12,
                          blurY: 12,
                          clipBorderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    Overlay.of(context, rootOverlay: true).insert(_dropdownOverlay!);
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  void _onSelect(RegionOption region) {
    _hideDropdown();
    setState(() {
      _selectedRegionLabel = region.label;
    });
    widget.onRegionSelected?.call(region.label);
  }

  @override
  void didUpdateWidget(covariant UniversityFilterChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If parent changes selectedRegion, update local state
    if (widget.selectedRegion != oldWidget.selectedRegion) {
      setState(() {
        _selectedRegionLabel = widget.selectedRegion;
      });
    }
  }

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }

  // Helper to calculate the width needed for a given label (text + icon)
  double _calculateChipWidth(BuildContext context, String label) {
    final textStyle = const TextStyle(fontSize: 16);
    final textScale = MediaQuery.of(context).textScaleFactor;
    final textPainter = TextPainter(
      text: TextSpan(text: label, style: textStyle),
      textDirection: TextDirection.ltr,
      textScaleFactor: textScale,
      maxLines: 1,
    )..layout();
    // text + spacing + dropdown icon + padding
    double width = textPainter.width + 8 + 24 + 32;
    return width;
  }

  @override
  Widget build(BuildContext context) {
    // Show the selected region label, or the placeholder "Region" if none selected
    final RegionOption selected = _regions.firstWhere(
      (r) => r.label == (_selectedRegionLabel ?? 'Region'),
      orElse: () => _regions[0],
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (_dropdownOpen) {
            _hideDropdown();
          } else {
            _showDropdown();
          }
          setState(() {});
        },
        child: Container(
          // Remove fixed width, let the chip expand as per text
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey[400]!,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              // Glass effect for chip
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Let the chip expand as per content
                children: [
                  // Show the full region label, never ellipsis, never wrap
                  Text(
                    selected.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.clip,
                    softWrap: false,
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _dropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ).asGlass(
              tintColor: Colors.white.withOpacity(0.15),
              blurX: 12,
              blurY: 12,
              clipBorderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}
