import 'package:flutter/material.dart';

class RateBorrowerDialog {
  static void show(BuildContext context) {
    int selectedRating = 0;
    TextEditingController feedbackController = TextEditingController();
    bool dark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: dark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      "Rate this Borrower",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ⭐ Animated Star Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        bool filled = index < selectedRating;

                        return AnimatedScale(
                          duration: const Duration(milliseconds: 150),
                          scale: filled ? 1.2 : 1.0,
                          child: IconButton(
                            onPressed: () {
                              setState(() => selectedRating = index + 1);
                            },
                            icon: Icon(
                              filled ? Icons.star_rounded : Icons.star_border_rounded,
                              color: Colors.amber,
                              size: 36,
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    // 📝 Feedback TextField
                    TextField(
                      controller: feedbackController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Write feedback (optional)",
                        hintStyle: TextStyle(
                          color: dark ? Colors.white54 : Colors.black54,
                        ),
                        filled: true,
                        fillColor: dark ? Colors.white10 : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: dark ? Colors.white24 : Colors.grey.shade300,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: dark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // CANCEL + DONE Buttons
                    Row(
                      children: [
                        // Cancel
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 46,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: dark ? Colors.white54 : Colors.grey.shade400,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: dark ? Colors.white70 : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Done
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: () {
                                if (selectedRating == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please select a rating."),
                                    ),
                                  );
                                  return;
                                }

                                Navigator.pop(context);

                                // 🎉 Animated Success Popup
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    Future.delayed(const Duration(milliseconds: 900), () {
                                      Navigator.pop(context);
                                    });

                                    return Center(
                                      child: AnimatedScale(
                                        duration: const Duration(milliseconds: 300),
                                        scale: 1.1,
                                        child: Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 12,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(Icons.check_circle_rounded,
                                                  size: 60, color: Colors.green),
                                              SizedBox(height: 10),
                                              Text(
                                                "Rating Submitted!",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Done",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
