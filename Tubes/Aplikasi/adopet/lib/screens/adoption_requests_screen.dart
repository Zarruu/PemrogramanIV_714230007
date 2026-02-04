import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/adoption.dart';
import '../providers/adoption_provider.dart';
import '../utils/constants.dart';

class AdoptionRequestsScreen extends StatelessWidget {
  const AdoptionRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Adoption Requests'),
          backgroundColor: AppColors.secondary,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              Tab(
                child: Consumer<AdoptionProvider>(
                  builder: (context, provider, _) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.pending_actions, size: 16),
                      const SizedBox(width: 4),
                      Text('Pending (${provider.pendingCount})', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 16),
                    SizedBox(width: 4),
                    Text('Approved', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cancel, size: 16),
                    SizedBox(width: 4),
                    Text('Rejected', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Consumer<AdoptionProvider>(
          builder: (context, provider, _) => TabBarView(
            children: [
              _buildRequestList(context, provider.getAdoptionsByStatus('pending'), true),
              _buildRequestList(context, provider.getAdoptionsByStatus('approved'), false),
              _buildRequestList(context, provider.getAdoptionsByStatus('rejected'), false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestList(BuildContext context, List<Adoption> requests, bool showActions) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No requests',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      itemCount: requests.length,
      itemBuilder: (context, index) => _buildRequestCard(context, requests[index], showActions),
    );
  }

  Widget _buildRequestCard(BuildContext context, Adoption adoption, bool showActions) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Info Row
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  child: Image.network(
                    adoption.petImageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.primaryLight,
                      child: const Icon(Icons.pets, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Request for ${adoption.petName}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDate(adoption.createdAt),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(adoption.status),
              ],
            ),
            const Divider(height: 24),
            
            // Applicant Info
            _buildInfoRow(Icons.person, 'Name', adoption.applicantName),
            _buildInfoRow(Icons.phone, 'Phone', adoption.applicantPhone),
            _buildInfoRow(Icons.email, 'Email', adoption.applicantEmail),
            _buildInfoRow(Icons.home, 'Address', adoption.applicantAddress),
            const SizedBox(height: 8),
            Text(
              'Reason:',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              adoption.reason,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            
            // Action Buttons (for pending only)
            if (showActions) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showConfirmDialog(
                        context,
                        'Approve Request',
                        'Approve adoption request from ${adoption.applicantName}?',
                        AppColors.success,
                        () => context.read<AdoptionProvider>().approveAdoption(adoption.id!),
                      ),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showConfirmDialog(
                        context,
                        'Reject Request',
                        'Reject adoption request from ${adoption.applicantName}?',
                        AppColors.error,
                        () => context.read<AdoptionProvider>().rejectAdoption(adoption.id!),
                      ),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Reject'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;
    switch (status) {
      case 'approved':
        color = AppColors.success;
        icon = Icons.check_circle;
        break;
      case 'rejected':
        color = AppColors.error;
        icon = Icons.cancel;
        break;
      default:
        color = AppColors.warning;
        icon = Icons.pending;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    Color color,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Request ${title.toLowerCase()}d'),
                  backgroundColor: color,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            child: Text(title.split(' ').first),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
