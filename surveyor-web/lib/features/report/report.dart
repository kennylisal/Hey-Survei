import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/features/report/widget/container_report_soal.dart';
import 'package:hei_survei/features/report/widget/sidebar_report.dart';

class HalamanReport extends ConsumerStatefulWidget {
  const HalamanReport({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HalamanReportState();
}

class _HalamanReportState extends ConsumerState<HalamanReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Container(
                width: constraints.maxWidth * 0.25,
                height: double.infinity,
                child: SideBarReport(),
              ),
              Container(
                width: constraints.maxWidth * 0.745,
                height: double.infinity,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      width: constraints.maxWidth > 1400
                          ? 1050
                          : constraints.maxWidth * 0.745,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: ContainerReportSoal(idForm: 'idform'),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
