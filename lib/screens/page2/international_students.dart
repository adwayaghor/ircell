import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/providers/internship_provider.dart';

class MobilityRequest {
  final String id;
  final String destination;
  final DateTime dateTime;
  final String purpose;
  final String
  status; // 'pending', 'faculty_approved', 'fully_approved', 'rejected'
  final bool facultyApproval;
  final bool wardenApproval;
  final DateTime? facultyApprovedAt;
  final DateTime? wardenApprovedAt;

  MobilityRequest({
    required this.id,
    required this.destination,
    required this.dateTime,
    required this.purpose,
    required this.status,
    required this.facultyApproval,
    required this.wardenApproval,
    this.facultyApprovedAt,
    this.wardenApprovedAt,
  });
}

class InternationalStudentsPage extends StatefulWidget {
  const InternationalStudentsPage({super.key});

  @override
  State<InternationalStudentsPage> createState() =>
      _InternationalStudentsPageState();
}

class _InternationalStudentsPageState extends State<InternationalStudentsPage> {
  final user = Auth().currentUser;
  String? uid;
  @override
  void initState() {
    super.initState();
    uid = user?.uid;
  }
  // Mock data
  final List<InboundInternship> mockInternships = [
    InboundInternship(
      id: '1',
      title: 'AI Research Internship',
      university: 'Technical University of Berlin',
      country: 'Germany',
      topic: 'Machine Learning & Computer Vision',
      duration: '6 months',
      status: 'Active',
      coordinator: 'Dr. Kumar Sharma',
      description:
          'Research internship focusing on advanced AI applications in healthcare and autonomous systems.',
      announcements: [
        'Welcome orientation on Monday 9 AM',
        'Lab access cards available at reception',
        'Weekly progress meetings every Friday',
      ],
    ),
    InboundInternship(
      id: '2',
      title: 'Sustainable Engineering Project',
      university: 'École Polytechnique',
      country: 'France',
      topic: 'Environmental Engineering',
      duration: '4 months',
      status: 'Starting Soon',
      coordinator: 'Prof. Anita Desai',
      description:
          'Collaborative project on sustainable urban development and green technology solutions.',
      announcements: [
        'Project kickoff meeting scheduled',
        'Required documents submission deadline: June 1st',
      ],
    ),
  ];

  final List<MobilityRequest> mockMobilityRequests = [
    MobilityRequest(
      id: '1',
      destination: 'City Center Mall',
      dateTime: DateTime.now().add(Duration(days: 2)),
      purpose: 'Shopping and cultural exploration',
      status: 'faculty_approved',
      facultyApproval: true,
      wardenApproval: false,
      facultyApprovedAt: DateTime.now().subtract(Duration(hours: 2)),
    ),
    MobilityRequest(
      id: '2',
      destination: 'India Gate, Delhi',
      dateTime: DateTime.now().add(Duration(days: 5)),
      purpose: 'Tourist visit with fellow students',
      status: 'pending',
      facultyApproval: false,
      wardenApproval: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.blueGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppTheme.textPrimary(context),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'International Students',
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(
                        color: AppTheme.textPrimary(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor(context),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Inbound Internships Section
                        _buildInboundInternshipsSection(),

                        const SizedBox(height: 32),

                        // Mobility Section
                        _buildMobilitySection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInboundInternshipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Inbound Internships',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mockInternships.length,
            itemBuilder: (context, index) {
              final internship = mockInternships[index];
              return _buildInternshipCard(internship);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInternshipCard(InboundInternship internship) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: AppTheme.cardDecoration(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showInternshipDetails(internship),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            internship.status == 'Active'
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        internship.status,
                        style: TextStyle(
                          color:
                              internship.status == 'Active'
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppTheme.textSecondary(context),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  internship.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary(context),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(
                      Icons.school,
                      size: 16,
                      color: AppTheme.textSecondary(context),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        internship.university,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.textSecondary(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      internship.country,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary(context),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppTheme.textSecondary(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      internship.duration,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary(context),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  internship.topic,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Campus Mobility',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showRequestMobilityDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Request'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Text(
          'Exit permissions require approval from both IR Faculty and Hostel Warden',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary(context),
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 16),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mockMobilityRequests.length,
          itemBuilder: (context, index) {
            final request = mockMobilityRequests[index];
            return _buildMobilityRequestCard(request);
          },
        ),
      ],
    );
  }

  Widget _buildMobilityRequestCard(MobilityRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppTheme.cardDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.destination,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(request.status),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.textSecondary(context),
                ),
                const SizedBox(width: 4),
                Text(
                  '${request.dateTime.day}/${request.dateTime.month}/${request.dateTime.year} at ${request.dateTime.hour}:${request.dateTime.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              'Purpose: ${request.purpose}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary(context),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _buildApprovalStatus(
                  'IR Faculty',
                  request.facultyApproval,
                  request.facultyApprovedAt,
                ),
                const SizedBox(width: 16),
                _buildApprovalStatus(
                  'Hostel Warden',
                  request.wardenApproval,
                  request.wardenApprovedAt,
                ),
              ],
            ),

            if (request.status == 'faculty_approved')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ElevatedButton.icon(
                  onPressed: () => _showQRCodeDialog(),
                  icon: const Icon(Icons.qr_code, size: 18),
                  label: const Text('Get Warden Approval'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        text = 'Pending';
        break;
      case 'faculty_approved':
        color = Colors.blue;
        text = 'Faculty Approved';
        break;
      case 'fully_approved':
        color = Colors.green;
        text = 'Approved';
        break;
      case 'rejected':
        color = Colors.red;
        text = 'Rejected';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildApprovalStatus(
    String approver,
    bool approved,
    DateTime? approvedAt,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              approved
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: approved ? Colors.green : Colors.grey,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  approved ? Icons.check_circle : Icons.pending,
                  size: 16,
                  color: approved ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    approver,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: approved ? Colors.green[700] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            if (approved && approvedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  'Approved ${_formatTime(approvedAt)}',
                  style: TextStyle(fontSize: 10, color: Colors.green[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showInternshipDetails(InboundInternship internship) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor(context),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          internship.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: AppTheme.textPrimary(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _buildDetailRow('University', internship.university),
                        _buildDetailRow('Country', internship.country),
                        _buildDetailRow('Topic', internship.topic),
                        _buildDetailRow('Duration', internship.duration),
                        _buildDetailRow('Coordinator', internship.coordinator),

                        const SizedBox(height: 24),

                        Text(
                          'Description',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          internship.description,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary(context),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          'Announcements',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        ...internship.announcements
                            .map(
                              (announcement) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.announcement,
                                      size: 16,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        announcement,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.textPrimary(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestMobilityDialog() {
    final destinationController = TextEditingController();
    final purposeController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.cardColor(context),
            title: Text(
              'Request Campus Exit',
              style: TextStyle(color: AppTheme.textPrimary(context)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: destinationController,
                  style: TextStyle(color: AppTheme.textPrimary(context)),
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                    hintText: 'Where are you going?',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: purposeController,
                  style: TextStyle(color: AppTheme.textPrimary(context)),
                  decoration: const InputDecoration(
                    labelText: 'Purpose',
                    hintText: 'Why are you going?',
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Date & Time',
                    style: TextStyle(color: AppTheme.textPrimary(context)),
                  ),
                  subtitle: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} at ${selectedTime.format(context)}',
                    style: TextStyle(color: AppTheme.textSecondary(context)),
                  ),
                  trailing: Icon(
                    Icons.calendar_today,
                    color: AppTheme.textSecondary(context),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (time != null) {
                        setState(() {
                          selectedDate = date;
                          selectedTime = time;
                        });
                      }
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppTheme.textSecondary(context)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (destinationController.text.isNotEmpty &&
                      purposeController.text.isNotEmpty) {
                    // Add request logic here
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mobility request submitted!'),
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
    );
  }

  void _showQRCodeDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.cardColor(context),
            title: Text(
              'Warden Approval',
              style: TextStyle(color: AppTheme.textPrimary(context)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  size: 64,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Show this screen to the hostel warden and scan the QR code at their desk to get approval.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary(context)),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Approval Code: WRD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppTheme.textSecondary(context)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Warden approval received!')),
                  );
                },
                child: const Text('Confirm Approval'),
              ),
            ],
          ),
    );
  }
}
