import 'package:flutter/material.dart';
import '../../../../utils/formatters/iconsNoPad.dart';

class ViewDetailNotif extends StatefulWidget {
  final String borrowerName;
  final double amount;
  final String repaymentType;
  final String dueDate;
  final String notes;
  final String requestedDate;
  final String? requestId;
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;

  const ViewDetailNotif({
    super.key,
    required this.borrowerName,
    required this.amount,
    required this.repaymentType,
    required this.dueDate,
    required this.notes,
    required this.requestedDate,
    this.requestId,
    this.onApprove,
    this.onDecline,
  });

  @override
  State<ViewDetailNotif> createState() => _ViewDetailNotifState();
}

class _ViewDetailNotifState extends State<ViewDetailNotif> {
  String status = "Pending";

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  void approveRequest() {
    setState(() => status = "Approved");
    if (widget.onApprove != null) {
      widget.onApprove!();
    }
  }

  void rejectRequest() {
    setState(() => status = "Rejected");
    if (widget.onDecline != null) {
      widget.onDecline!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),

                  // Avatar + Name
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 36, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.borrowerName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "wants to borrow money",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Status Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: getStatusColor().withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: getStatusColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Amount Display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        UIconsNoPad.pesoSign(size: 20, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          widget.amount.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Details
                  _buildDetailRow("Repayment", widget.repaymentType),
                  _buildDetailRow("Due Date", widget.dueDate),
                  _buildDetailRow("Notes", widget.notes.isNotEmpty ? widget.notes : "None"),
                  _buildDetailRow("Requested", widget.requestedDate),

                  const SizedBox(height: 25),

                  // Buttons
                  if (status == "Pending")
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: rejectRequest,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.redAccent),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.close, color: Colors.redAccent),
                            label: const Text(
                              "Reject",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: approveRequest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text(
                              "Approve",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "This request has been $status.",
                          style: TextStyle(
                            fontSize: 13,
                            color: getStatusColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // ❌ Close button
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.close,
                color: Colors.grey,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}