import 'package:flutter/material.dart';

class UtangFormPopup extends StatefulWidget {
  const UtangFormPopup({super.key});

  @override
  State<UtangFormPopup> createState() => _UtangFormPopupState();
}

class _UtangFormPopupState extends State<UtangFormPopup> {
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
      backgroundColor: Colors.blueGrey[100],
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// --- Header Row (Title + Close Button)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Utang Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// --- Amount
            _buildTextField("Amount (₱)*", "Enter amount", controller: amountController, keyboardType: TextInputType.number),

            const SizedBox(height: 12),

            /// --- Repayment Plan
            _buildDropdown(),

            const SizedBox(height: 12),

            /// --- Conditional Fields
            if (repaymentType == "Single Repayment")
              _buildTextField("Preferred Due Date*", "dd/mm/yyyy", controller: dueDateController, suffixIcon: Icons.calendar_today),
            if (repaymentType == "Multiple Repayment") Row(
              children: [
                Expanded(
                  child: _buildTextField("Count of Gives*", "Enter number of payments",
                    controller: countOfGivesController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField("Interest (%)", "Enter interest percentage",
                    controller: interestController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// --- Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Save", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey[600]) : null,
            filled: true,
            fillColor: Colors.blueGrey?.withOpacity(0.7),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blueGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade900),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Repayment Plan", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey?.withOpacity(0.7),
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: repaymentType,
              items: const [
                DropdownMenuItem(value: "Single Repayment", child: Text("Single Repayment")),
                DropdownMenuItem(value: "Multiple Repayment", child: Text("Multiple Repayment")),
              ],
              onChanged: (value) => setState(() => repaymentType = value!),
            ),
          ),
        ),
      ],
    );
  }
}