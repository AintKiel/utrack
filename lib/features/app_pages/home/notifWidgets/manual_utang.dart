import 'package:flutter/material.dart';
import '../../../../services/loan_request_service.dart';
import '../../../../services/enhanced_credit_service.dart';

class RequestUtangPopup extends StatefulWidget {
  const RequestUtangPopup({super.key});

  @override
  State<RequestUtangPopup> createState() => _RequestUtangPopupState();
}

class _RequestUtangPopupState extends State<RequestUtangPopup> {
  String repaymentType = "Single Repayment";
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController countOfGivesController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  bool isLoading = false;
  String? validatedUserName;

  Future<void> _validateUserId() async {
    final userId = userIdController.text.trim();
    if (userId.isEmpty) return;

    setState(() => isLoading = true);
    final result = await LoanRequestService.validateUserId(userId);
    setState(() => isLoading = false);

    if (result['exists'] == true) {
      setState(() => validatedUserName = result['name']);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ User found: ${result['name']}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      setState(() => validatedUserName = null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ User not found. Please check the User ID.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _submitLoanRequest() async {
    // Validation
    if (userIdController.text.trim().isEmpty) {
      _showError('Please enter a User ID');
      return;
    }
    if (amountController.text.trim().isEmpty) {
      _showError('Please enter an amount');
      return;
    }
    if (dueDateController.text.trim().isEmpty) {
      _showError(repaymentType == 'Single Repayment' 
          ? 'Please enter a due date' 
          : 'Please enter a start date');
      return;
    }
    if (repaymentType == 'Multiple Repayment' && countOfGivesController.text.trim().isEmpty) {
      _showError('Please enter installment count');
      return;
    }

    final amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    // Validate 21-day limit for single repayment
    if (repaymentType == 'Single Repayment') {
      final dueDate = _parseDateString(dueDateController.text.trim());
      if (dueDate != null) {
        if (!EnhancedCreditService.isValidDueDate(dueDate)) {
          _showError('Due date must be between 1-21 days from today');
          return;
        }
      } else {
        _showError('Please enter a valid date (dd/mm/yyyy)');
        return;
      }
    }

    // Auto-calculate interest for multiple repayment
    double? finalInterest;
    if (repaymentType == 'Multiple Repayment') {
      final installmentCount = int.tryParse(countOfGivesController.text.trim());
      if (installmentCount != null && installmentCount > 0) {
        finalInterest = EnhancedCreditService.calculateInstallmentInterest(installmentCount);
      }
    } else {
      // Use manual interest for single repayment if provided
      if (interestController.text.trim().isNotEmpty) {
        finalInterest = double.tryParse(interestController.text.trim());
      }
    }

    setState(() => isLoading = true);

    final result = await LoanRequestService.requestLoan(
      lenderUserId: userIdController.text.trim(),
      amount: amount,
      repaymentType: repaymentType,
      dueDate: dueDateController.text.trim(), // Pass date for both types
      installmentCount: repaymentType == 'Multiple Repayment' 
          ? int.tryParse(countOfGivesController.text.trim()) 
          : null,
      interestRate: finalInterest,
      notes: noteController.text.trim().isNotEmpty ? noteController.text.trim() : null,
    );

    setState(() => isLoading = false);

    if (result['success'] == true) {
      if (mounted) {
        // The loan request was created successfully
        // The LoanRequestService already created the notification in the lender's collection
        // We don't need to generate notifications here since it's already done
        print('✅ Loan request created - notification already sent to lender');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Loan request sent to ${result['lenderName']}!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      _showError(result['error'] ?? 'Failed to create loan request');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Parse date string (dd/mm/yyyy) to DateTime
  DateTime? _parseDateString(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Invalid date format
    }
    return null;
  }

  /// Show date picker and update the date controller
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), // 1 year from now
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Your app's primary color
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Format date as dd/mm/yyyy
      final formattedDate = "${picked.day.toString().padLeft(2, '0')}/"
          "${picked.month.toString().padLeft(2, '0')}/"
          "${picked.year}";
      controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// --- Main content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),

                /// --- Title + Subtitle
                const Text(
                  "Request Utang",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Fill in the details below to continue.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 28),

                /// --- User ID
                _buildTextField("User ID", "Type User ID",
                    controller: userIdController,
                    suffixIcon: validatedUserName != null ? Icons.check_circle : null,
                    onChanged: (value) {
                      if (validatedUserName != null) {
                        setState(() => validatedUserName = null);
                      }
                    }),
                if (validatedUserName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '✅ $validatedUserName',
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: isLoading ? null : _validateUserId,
                  icon: Icon(
                    isLoading ? Icons.hourglass_empty : Icons.search,
                    size: 16,
                  ),
                  label: Text(isLoading ? 'Validating...' : 'Validate User ID'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 30),
                  ),
                ),
                const SizedBox(height: 14),

                /// --- Amount
                _buildTextField("Amount*",
                    "Enter amount in Peso",
                    controller: amountController,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 14),

                /// --- Repayment Plan
                _buildDropdown(),
                const SizedBox(height: 14),

                /// --- Conditional Fields
                if (repaymentType == "Single Repayment")
                  _buildTextField("Preferred Due Date*", "dd/mm/yyyy",
                      controller: dueDateController,
                      suffixIcon: Icons.calendar_today,
                      isDateField: true),

                if (repaymentType == "Multiple Repayment")
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField("Installment Count*",
                                "Enter number of months",
                                controller: countOfGivesController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  final months = int.tryParse(value);
                                  if (months != null && months > 0) {
                                    final interest = EnhancedCreditService.calculateInstallmentInterest(months);
                                    interestController.text = interest.toString();
                                  } else {
                                    interestController.text = '';
                                  }
                                }),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField("Interest (%) - Auto",
                                "Auto-calculated",
                                controller: interestController,
                                keyboardType: TextInputType.number,
                                enabled: false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildTextField("Start Date*", "dd/mm/yyyy",
                          controller: dueDateController,
                          suffixIcon: Icons.calendar_today,
                          isDateField: true),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue.shade600, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Interest = (Months + 1)%. Example: 3 months = 4% interest',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 14),

                /// --- Notes
                _buildTextField("Notes (Optional)",
                    "Add any additional notes...",
                    controller: noteController,
                    maxLines: 2),
                const SizedBox(height: 24),

                /// --- Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitLoanRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// --- Exit button (top-right)
          Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded,
                    size: 18, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Flat minimalist text field
  Widget _buildTextField(
      String label,
      String hint, {
        TextEditingController? controller,
        TextInputType? keyboardType,
        int maxLines = 1,
        IconData? suffixIcon,
        Function(String)? onChanged,
        bool enabled = true,
        bool isDateField = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          enabled: enabled,
          style: TextStyle(
            fontSize: 14, 
            color: enabled ? Colors.black87 : Colors.grey[600],
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
            suffixIcon: suffixIcon != null
                ? (isDateField 
                    ? GestureDetector(
                        onTap: () => _selectDate(context, controller!),
                        child: Icon(suffixIcon, size: 18, color: Colors.grey[500]),
                      )
                    : Icon(suffixIcon, size: 18, color: Colors.grey[500]))
                : null,
            isDense: true, // makes height smaller
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            filled: true,
            fillColor: enabled ? Colors.transparent : Colors.grey[50],
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6366F1), width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  // --- Flat dropdown
  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Repayment Plan",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 4),
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: repaymentType,
              isExpanded: true,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              items: const [
                DropdownMenuItem(
                    value: "Single Repayment",
                    child: Text("Single Repayment")),
                DropdownMenuItem(
                    value: "Multiple Repayment",
                    child: Text("Multiple Repayment")),
              ],
              onChanged: (value) => setState(() => repaymentType = value!),
            ),
          ),
        ),
      ],
    );
  }
}