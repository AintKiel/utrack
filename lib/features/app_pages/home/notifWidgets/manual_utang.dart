import 'package:flutter/material.dart';

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
                    controller: userIdController),
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
                      suffixIcon: Icons.calendar_today),

                if (repaymentType == "Multiple Repayment")
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField("Installment Count*",
                            "Enter number of payments",
                            controller: countOfGivesController,
                            keyboardType: TextInputType.number),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField("Interest (%)",
                            "Enter interest percentage",
                            controller: interestController,
                            keyboardType: TextInputType.number),
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          elevation: 0,
                        ),
                        child: const Text(
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
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, size: 18, color: Colors.grey[500])
                : null,
            isDense: true, // makes height smaller
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            filled: true,
            fillColor: Colors.transparent,
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