import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideBarReport extends ConsumerStatefulWidget {
  const SideBarReport({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SideBarReportState();
}

class _SideBarReportState extends ConsumerState<SideBarReport> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [],
          ),
        );
      },
    );
  }
}
