import 'package:flutter/material.dart';
import 'package:mobile/components/ui/dashboard_shell.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Campaign',
      body: Center(
        child: Text(
          'Campaign screen coming soon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
