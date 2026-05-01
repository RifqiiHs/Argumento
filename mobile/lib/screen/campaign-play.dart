import 'package:flutter/material.dart';
import 'package:mobile/components/ui/dashboard_shell.dart';

class CampaignPlayScreen extends StatefulWidget {
  const CampaignPlayScreen({super.key});

  @override
  State<CampaignPlayScreen> createState() => _CampaignPlayScreenState();
}

class _CampaignPlayScreenState extends State<CampaignPlayScreen> {
  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Campaign Play',
      body: Center(
        child: Text(
          'Campaign play screen coming soon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
