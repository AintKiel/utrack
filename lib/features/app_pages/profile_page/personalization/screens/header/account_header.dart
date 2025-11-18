import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../common/widgets/custom_shapes/containers/tertiary_header_container.dart';

class AccountHeader extends StatelessWidget {
  final String fullName;
  final String userId;
  final String? profilePicUrl;

  const AccountHeader({
    super.key,
    required this.fullName,
    required this.userId,
    this.profilePicUrl,
  });

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "U";
    List<String> parts = name.trim().split(" ");
    return parts.length == 1
        ? parts[0][0].toUpperCase()
        : (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(fullName);

    return UTertiaryHeaderContainer(
      height: 230,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            /// ---------------- ACCOUNT TITLE ----------------
            Text(
              "Account",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            /// ---------------- PROFILE ROW ----------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------- AVATAR ----------
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      backgroundImage: (profilePicUrl != null &&
                          profilePicUrl!.isNotEmpty)
                          ? NetworkImage(profilePicUrl!)
                          : null,
                      child: (profilePicUrl == null ||
                          profilePicUrl!.isEmpty)
                          ? Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                          : null,
                    ),

                    /// ------ EDIT ICON ------
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 22,
                        width: 22,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 14,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 16),

                /// ---------- NAME + COPY USER ID ----------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Text(
                            "Copy User ID",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white70),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: userId),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("User ID copied!"),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.copy,
                              color: Colors.white70,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}