import 'package:flutter/material.dart';

class ToggleButtonTab extends StatefulWidget {
  ToggleButtonTab({
    super.key,
    required this.onPressed,
    required this.listBoolToggle,
  });
  Function(int)? onPressed;
  List<bool> listBoolToggle;
  @override
  State<ToggleButtonTab> createState() => _ToggleButtonTabState();
}

class _ToggleButtonTabState extends State<ToggleButtonTab> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderColor: Colors.black,
      fillColor: Colors.indigo.shade200,
      borderWidth: 2,
      selectedBorderColor: Colors.black,
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      onPressed: widget.onPressed,
      isSelected: widget.listBoolToggle,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 2),
          child: Text(
            "Utama",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 2),
          child: Text(
            "Satuan",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
