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
  final bool isActive; // New parameter for active state
  final Color? activeGlowColor; // New parameter for glow color

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
    this.isActive = false, // Default to false
    this.activeGlowColor, // Optional glow color
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

    // Calculate dropdown width as max of all options
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
    final double dropdownWidth = widget.options
        .map((o) => _calculateWidth(widget.labelBuilder(o)))
        .reduce((a, b) => a > b ? a : b);

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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.leadingBuilder != null)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: widget.leadingBuilder!(option),
                                    ),
                                  Text(
                                    widget.labelBuilder(option),
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

  @override
  Widget build(BuildContext context) {
    final T? selectedValue = _selectedValue;
    final String label = selectedValue != null
        ? widget.labelBuilder(selectedValue)
        : (widget.placeholder ?? 'Select');
    final double chipWidth = _calculateChipWidth(context, label);

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
              color: widget.isActive && widget.activeGlowColor != null
                  ? widget.activeGlowColor!.withOpacity(0.8)
                  : Colors.grey[400]!,
              width: widget.isActive ? 2 : 1,
            ),
            boxShadow: widget.isActive && widget.activeGlowColor != null ? [
              BoxShadow(
                color: widget.activeGlowColor!.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ] : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              // Glass effect for chip
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.leadingBuilder != null && selectedValue != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: widget.leadingBuilder!(selectedValue),
                    ),
                  Text(
                    label,
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
              tintColor: widget.chipTint,
              blurX: widget.blur,
              blurY: widget.blur,
              clipBorderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
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
    // text + spacing + dropdown icon + padding
    double width = textPainter.width + 8 + 24 + 32;
    return width;
  }
} 