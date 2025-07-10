import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

class GlassDropdownChip<T> extends StatefulWidget {
  final List<T> options;
  final T? selectedValue;
  final ValueChanged<T?>? onChanged;
  final String Function(T) labelBuilder;
  final Widget Function(T)? leadingBuilder;
  final double iconSize;
  final String? placeholder;
  final double blur;
  final double blurDropdown;
  final Color chipTint;
  final Color dropdownTint;
  final bool isActive;
  final Color? activeGlowColor;

  const GlassDropdownChip({
    super.key,
    required this.options,
    required this.labelBuilder,
    this.leadingBuilder,
    this.selectedValue,
    this.onChanged,
    this.iconSize = 20,
    this.placeholder,
    this.blur = 12,
    this.blurDropdown = 12,
    this.chipTint = const Color(0x26FFFFFF),
    this.dropdownTint = const Color(0x26FFFFFF),
    this.isActive = false,
    this.activeGlowColor,
  });

  @override
  State<GlassDropdownChip<T>> createState() => _GlassDropdownChipState<T>();
}

class _GlassDropdownChipState<T> extends State<GlassDropdownChip<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _dropdownOverlay;
  T? _selectedValue;

  bool get _dropdownOpen => _dropdownOverlay != null;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  void didUpdateWidget(covariant GlassDropdownChip<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      setState(() {
        _selectedValue = widget.selectedValue;
      });
    }
  }

  void _showDropdown() {
    if (_dropdownOverlay != null) return;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double chipWidth = renderBox.size.width;

    double _calculateWidth(String label) {
      final textStyle = const TextStyle(fontSize: 16);
      final textScale = MediaQuery.of(context).textScaleFactor;
      final textPainter = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
        textScaleFactor: textScale,
        maxLines: 1,
      )..layout();
      return textPainter.width + 8 + 24 + 32;
    }
    final double widestOption = widget.options.isNotEmpty
        ? widget.options.map((o) => _calculateWidth(widget.labelBuilder(o))).reduce((a, b) => a > b ? a : b)
        : 0;
    final double dropdownWidth = chipWidth > widestOption ? chipWidth : widestOption;

    _dropdownOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _hideDropdown();
                  setState(() {});
                },
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, renderBox.size.height + 8),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                elevation: 0,
                child: Container(
                  width: dropdownWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: widget.options.map((option) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              _onSelect(option);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  if (widget.leadingBuilder != null)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: widget.leadingBuilder!(option),
                                    ),
                                  Expanded(
                                    child: Text(
                                      widget.labelBuilder(option),
                                      style: const TextStyle(fontSize: 16, color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ).asGlass(
                        tintColor: widget.dropdownTint,
                        blurX: widget.blurDropdown,
                        blurY: widget.blurDropdown,
                        clipBorderRadius: BorderRadius.circular(16),
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

  void _onSelect(T option) {
    _hideDropdown();
    setState(() {
      _selectedValue = option;
    });
    widget.onChanged?.call(option);
  }

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }

  double _calculateChipWidth(BuildContext context, String label) {
    final textStyle = const TextStyle(fontSize: 16);
    final textScale = MediaQuery.of(context).textScaleFactor;
    final textPainter = TextPainter(
      text: TextSpan(text: label, style: textStyle),
      textDirection: TextDirection.ltr,
      textScaleFactor: textScale,
      maxLines: 1,
    )..layout();
    return textPainter.width + 24 + 32;
  }

  @override
  Widget build(BuildContext context) {
    final T? selectedValue = _selectedValue;
    final String label = selectedValue != null
        ? widget.labelBuilder(selectedValue)
        : (widget.placeholder ?? 'Select');
    final double chipWidth = MediaQuery.of(context).size.width - 36; // 18px horizontal padding on each side in parent

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
          width: chipWidth,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: widget.isActive && widget.activeGlowColor != null
                ? [
                    BoxShadow(
                      color: widget.activeGlowColor!.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (widget.leadingBuilder != null && selectedValue != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: widget.leadingBuilder!(selectedValue),
                      ),
                    Flexible(
                      child: Text(
                        label,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _dropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.white,
                size: widget.iconSize,
              ),
            ],
          ),
        ).asGlass(
          tintColor: widget.chipTint,
          blurX: widget.blur,
          blurY: widget.blur,
          clipBorderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
} 