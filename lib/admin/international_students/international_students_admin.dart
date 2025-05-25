import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/mobility_request_provider.dart';

class InternationalStudentsAdmin extends StatefulWidget {
  const InternationalStudentsAdmin({super.key});

  @override
  State<InternationalStudentsAdmin> createState() => _InternationalStudentsAdminState();
}

class _InternationalStudentsAdminState extends State<InternationalStudentsAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('International Students Admin'),
        elevation: 2,
      ),
      body: const MobilityRequestsAdmin(),
    );
  }
}

class MobilityRequestsAdmin extends StatelessWidget {
  const MobilityRequestsAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.all(constraints.maxWidth > 600 ? 24.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mobility Requests',
                style: TextStyle(
                  fontSize: constraints.maxWidth > 600 ? 28 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: constraints.maxWidth > 600 ? 24 : 16),
              Expanded(
                child: _buildMobilityRequestsList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobilityRequestsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('student_mobility')
          .snapshots(),
      builder: (context, snapshot) {
        print('Stream state: ${snapshot.connectionState}');
        print('Has data: ${snapshot.hasData}');
        print('Has error: ${snapshot.hasError}');
        
        if (snapshot.hasError) {
          print('Firestore error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          print('No snapshot data');
          return const Center(child: Text('No data available'));
        }

        final docs = snapshot.data!.docs;
        print('Number of documents: ${docs.length}');
        
        if (docs.isEmpty) {
          return const Center(child: Text('No mobility requests found'));
        }

        // Debug: Print first document structure
        if (docs.isNotEmpty) {
          final firstDoc = docs.first.data() as Map<String, dynamic>;
          print('First document data: $firstDoc');
          print('First document ID: ${docs.first.id}');
        }

        // Convert Firestore documents to MobilityRequest objects
        final mobilityRequests = <MobilityRequest>[];
        
        for (final doc in docs) {
          try {
            final data = doc.data() as Map<String, dynamic>;
            print('Processing document ${doc.id}: $data');
            final request = MobilityRequest.fromMap(data, doc.id);
            mobilityRequests.add(request);
          } catch (e) {
            print('Error processing document ${doc.id}: $e');
          }
        }

        print('Successfully converted ${mobilityRequests.length} requests');

        if (mobilityRequests.isEmpty) {
          return const Center(child: Text('Error converting documents to MobilityRequest objects'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return ListView.builder(
              itemCount: mobilityRequests.length,
              itemBuilder: (context, index) {
                final request = mobilityRequests[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: constraints.maxWidth > 600 ? 20 : 16,
                  ),
                  child: MobilityRequestCard(
                    mobilityRequest: request,
                    isWideScreen: constraints.maxWidth > 600,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class MobilityRequestCard extends StatelessWidget {
  final MobilityRequest mobilityRequest;
  final bool isWideScreen;

  const MobilityRequestCard({
    super.key,
    required this.mobilityRequest,
    this.isWideScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(isWideScreen ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: isWideScreen ? 16 : 12),
            _buildDetailsSection(),
            SizedBox(height: isWideScreen ? 20 : 16),
            _buildApprovalSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 400;
        
        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mobilityRequest.destination,
                style: TextStyle(
                  fontSize: isWideScreen ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildStatusChip(mobilityRequest.status),
            ],
          );
        }
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                mobilityRequest.destination,
                style: TextStyle(
                  fontSize: isWideScreen ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            _buildStatusChip(mobilityRequest.status),
          ],
        );
      },
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          icon: Icons.flag,
          label: 'Purpose',
          value: mobilityRequest.purpose,
        ),
        SizedBox(height: isWideScreen ? 12 : 8),
        _buildDetailRow(
          icon: Icons.schedule,
          label: 'Date & Time',
          value: _formatDateTime(mobilityRequest.dateTime),
        ),
        if (mobilityRequest.facultyApprovedAt != null) ...[
          SizedBox(height: isWideScreen ? 12 : 8),
          _buildDetailRow(
            icon: Icons.check_circle,
            label: 'Faculty Approved',
            value: _formatDateTime(mobilityRequest.facultyApprovedAt!),
            valueColor: Colors.green,
          ),
        ],
        if (mobilityRequest.wardenApprovedAt != null) ...[
          SizedBox(height: isWideScreen ? 12 : 8),
          _buildDetailRow(
            icon: Icons.verified,
            label: 'Warden Approved',
            value: _formatDateTime(mobilityRequest.wardenApprovedAt!),
            valueColor: Colors.green,
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: isWideScreen ? 20 : 16,
          color: Colors.grey[600],
        ),
        SizedBox(width: isWideScreen ? 12 : 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isWideScreen ? 14 : 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isWideScreen ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 500;
        
        if (isNarrow) {
          return Column(
            children: [
              _buildApprovalCard(
                context,
                'Faculty',
                mobilityRequest.facultyApproval,
                onApprove: () => _handleApproval(context, 'faculty', true),
                onReject: () => _handleApproval(context, 'faculty', false),
              ),
              const SizedBox(height: 16),
              _buildWardenStatusCard(),
            ],
          );
        }
        
        return Row(
          children: [
            Expanded(
              child: _buildApprovalCard(
                context,
                'Faculty',
                mobilityRequest.facultyApproval,
                onApprove: () => _handleApproval(context, 'faculty', true),
                onReject: () => _handleApproval(context, 'faculty', false),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildWardenStatusCard(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildApprovalCard(
    BuildContext context,
    String role,
    bool isApproved, {
    required VoidCallback onApprove,
    required VoidCallback onReject,
  }) {
    final approvalColor = isApproved ? Colors.green : Colors.grey[400]!;
    
    return Container(
      padding: EdgeInsets.all(isWideScreen ? 16 : 12),
      decoration: BoxDecoration(
        color: isApproved
            ? Colors.green.withOpacity(0.05)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: approvalColor,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: approvalColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isApproved ? Icons.check_circle : Icons.pending,
                  color: approvalColor,
                  size: isWideScreen ? 20 : 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$role Approval',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: approvalColor,
                    fontSize: isWideScreen ? 16 : 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isWideScreen ? 16 : 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isVeryNarrow = constraints.maxWidth < 200;
              
              if (isVeryNarrow) {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: _buildActionButton(
                        icon: Icons.check,
                        label: 'Approve',
                        color: Colors.green,
                        onPressed: onApprove,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: _buildActionButton(
                        icon: Icons.close,
                        label: 'Reject',
                        color: Colors.red,
                        onPressed: onReject,
                      ),
                    ),
                  ],
                );
              }
              
              return Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.check,
                      label: 'Approve',
                      color: Colors.green,
                      onPressed: onApprove,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.close,
                      label: 'Reject',
                      color: Colors.red,
                      onPressed: onReject,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWardenStatusCard() {
    final approvalColor = mobilityRequest.wardenApproval ? Colors.green : Colors.grey[400]!;
    
    return Container(
      padding: EdgeInsets.all(isWideScreen ? 16 : 12),
      decoration: BoxDecoration(
        color: mobilityRequest.wardenApproval
            ? Colors.green.withOpacity(0.05)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: approvalColor,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: approvalColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  mobilityRequest.wardenApproval ? Icons.check_circle : Icons.pending,
                  color: approvalColor,
                  size: isWideScreen ? 20 : 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Warden Approval',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: approvalColor,
                    fontSize: isWideScreen ? 16 : 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isWideScreen ? 16 : 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isWideScreen ? 12 : 10,
              horizontal: isWideScreen ? 16 : 12,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: isWideScreen ? 18 : 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    mobilityRequest.wardenApproval 
                        ? 'Approved offline'
                        : 'Pending offline approval',
                    style: TextStyle(
                      fontSize: isWideScreen ? 14 : 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: isWideScreen ? 18 : 16),
      label: Text(
        label,
        style: TextStyle(fontSize: isWideScreen ? 14 : 12),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color, width: 1.5),
        padding: EdgeInsets.symmetric(
          vertical: isWideScreen ? 12 : 10,
          horizontal: isWideScreen ? 16 : 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        'at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(String status) {
  switch (status) {
    case 'faculty_approved':
      return Colors.blue;
    case 'fully_approved':
      return Colors.green;
    case 'rejected':
      return Colors.red;
    default:
      return Colors.orange;
  }
}

  Widget _buildStatusChip(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWideScreen ? 12 : 10,
        vertical: isWideScreen ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: isWideScreen ? 12 : 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Future<void> _handleApproval(
      BuildContext context, String role, bool approved) async {
    try {
      final updateData = <String, dynamic>{
        '${role}Approval': approved,
        '${role}ApprovedAt': FieldValue.serverTimestamp(),
      };

      // Update status based on faculty approval only
      if (role == 'faculty') {
        updateData['status'] = approved ? 'faculty_approved' : 'rejected';
      }

      await FirebaseFirestore.instance
          .collection('student_mobility')
          .doc(mobilityRequest.id)
          .update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$role approval ${approved ? 'granted' : 'revoked'}'),
          backgroundColor: approved ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update approval: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}