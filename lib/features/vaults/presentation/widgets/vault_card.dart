import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VaultCard extends StatelessWidget {
  const VaultCard({
    super.key,
    required this.name,
    required this.createdAt,
    required this.vaultId,
    required this.onTap,
  });

  final String name;
  final DateTime createdAt;
  final String vaultId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFFD3951);
    final formattedDate = DateFormat('MMM dd, yyyy').format(createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.folder,
                      color: primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Created: $formattedDate',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: primaryColor,
                    ),
                    onPressed: onTap,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.3, // Placeholder, could be dynamic based on vault usage
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '5 files',  // Placeholder, could be dynamic count
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '12.4 MB / 50 MB',  // Placeholder, could be dynamic size
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
