import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';

class AgCheckIcon extends StatefulWidget {
  final Future<bool> Function()? onSave;
  final bool enabled;
  final double size;
  final bool initialSuccess;

  const AgCheckIcon({
    super.key,
    this.onSave,
    this.enabled = true,
    this.size = 26,
    this.initialSuccess = false,
  });

  @override
  State<AgCheckIcon> createState() => _AgCheckIconState();
}

class _AgCheckIconState extends State<AgCheckIcon> {
  late bool isSuccess;

  @override
  void initState() {
    super.initState();
    isSuccess = widget.initialSuccess; // persist state
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return Icon(Icons.check_circle, size: widget.size, color: Colors.grey);
    }

    return IconButton(
      onPressed: () async {
        bool ok = true;

        if (widget.onSave != null) {
          ok = await widget.onSave!.call();
        }

        if (!mounted) return;

        setState(() => isSuccess = ok);
      },
      icon: Icon(
        Icons.check_circle,
        size: widget.size,
        color: isSuccess ? AgColors.colorPrimary : Colors.grey,
      ),
    );
  }
}
