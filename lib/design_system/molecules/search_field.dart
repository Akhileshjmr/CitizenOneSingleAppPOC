import 'package:citizenone_app/core/theme/tokens/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class SearchField extends StatefulWidget {
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  const SearchField({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.onClear,
    this.focusNode,
  });
  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _ctrl;
  bool _hasText = false;
  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? TextEditingController();
    _hasText = _ctrl.text.isNotEmpty;
    _ctrl.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    final has = _ctrl.text.isNotEmpty;
    if (has != _hasText) {
      setState(() {
        _hasText = has;
      });
    }
  }

  @override
  void dispose() {
    _ctrl.removeListener(_handleTextChanged);
    if (widget.controller == null) {
      _ctrl.dispose();
    }
    super.dispose();
  }

  void _clear() {
    _ctrl.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: _ctrl,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        textInputAction: TextInputAction.search,
        style: AppTypography.bodyLarge(context),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search…',
          hintStyle: AppTypography.bodyMedium(
            context,
          ).copyWith(color: Colors.grey),
          prefixIcon: const Icon(
            LucideIcons.search,
            size: 20,
            color: Colors.grey,
          ),
          suffixIcon: _hasText
              ? GestureDetector(
                  onTap: _clear,
                  behavior: HitTestBehavior.opaque,
                  child: const Icon(
                    LucideIcons.x,
                    size: 18,
                    color: Colors.grey,
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1),
          ),
        ),
      ),
    );
  }
}
