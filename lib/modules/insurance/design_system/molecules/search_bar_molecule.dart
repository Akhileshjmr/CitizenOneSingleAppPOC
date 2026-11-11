// =============================================================================
// SearchBarMolecule  —  MOLECULE
// -----------------------------------------------------------------------------
// Combines: BaseTextField + leading search icon + trailing clear button.
// The clear button is wired automatically based on whether the field has
// content. No feature/business logic.
// =============================================================================

import 'package:flutter/material.dart';
import '../atoms/atoms.dart';

class SearchBarMolecule extends StatefulWidget {
  const SearchBarMolecule({
    super.key,
    this.controller,
    this.hint = 'Search',
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  @override
  State<SearchBarMolecule> createState() => _SearchBarMoleculeState();
}

class _SearchBarMoleculeState extends State<SearchBarMolecule> {
  late final TextEditingController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
      _ownsController = true;
    } else {
      _controller = widget.controller!;
    }
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.isNotEmpty;
    return BaseTextField(
      controller: _controller,
      hint: widget.hint,
      autofocus: widget.autofocus,
      prefixIcon: Icons.search,
      suffixIcon: hasText ? Icons.close_rounded : null,
      onSuffixTap: hasText
          ? () {
              _controller.clear();
              widget.onChanged?.call('');
            }
          : null,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      textInputAction: TextInputAction.search,
    );
  }
}
