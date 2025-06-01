import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:secvault/features/vaults/presentation/widgets/my_action_button.dart';

class VaultDetails extends StatelessWidget {
  VaultDetails({
    super.key,
    required this.vaultId,
    required this.vaultName,
    required this.createdAt,
  });

  final String vaultId;
  final String vaultName;
  final DateTime createdAt;

  final List<Map<String, dynamic>> _files = [
    {
      'id': '1',
      'vaultId': 'v1',
      'fileName': 'personal_id.pdf',
      'uploadDate': '2025-05-12',
      'fileSize': '2.4 MB',
    },
    {
      'id': '2',
      'vaultId': 'v1',
      'fileName': 'passport_scan.jpg',
      'uploadDate': '2025-05-15',
      'fileSize': '1.8 MB',
    },
    {
      'id': '3',
      'vaultId': 'v1',
      'fileName': 'insurance_document.pdf',
      'uploadDate': '2025-05-18',
      'fileSize': '3.2 MB',
    },
    {
      'id': '4',
      'vaultId': 'v1',
      'fileName': 'tax_return_2024.pdf',
      'uploadDate': '2025-05-20',
      'fileSize': '5.7 MB',
    },
    {
      'id': '5',
      'vaultId': 'v1',
      'fileName': 'medical_records.pdf',
      'uploadDate': '2025-05-25',
      'fileSize': '8.3 MB',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Vault Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vault info card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vaultName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Created on ${DateFormat('MMM dd, yyyy').format(createdAt)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.folder,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 15),
                      // LinearProgressIndicator(
                      //   value: 0.45,
                      //   backgroundColor: const Color(0xFFE0E0E0),
                      //   valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      // ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       'Storage used',
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         color: Colors.grey[600],
                      //       ),
                      //     ),
                      //     Text(
                      //       '21.4 MB / 50 MB',
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.bold,
                      //         color: primaryColor,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyActionButton(icon: Icons.upload_file, label: 'Upload'),
                  MyActionButton(icon: Icons.share, label: 'Share'),
                  MyActionButton(icon: Icons.delete_outline, label: 'Delete'),
                ],
              ),
            ),

            // Files header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Secured Files',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 12,
                    child: Text(
                      '${_files.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Files list
            _buildFilesList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add file action
        },
        icon: const Icon(Icons.add),
        label: const Text('Add File'),
      ),
    );
  }

  Widget _buildFilesList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: _files.length,
      itemBuilder: (context, index) {
        final file = _files[index];
        final String fileExtension =
            file['fileName'].split('.').last.toLowerCase();

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            elevation: 2,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    fileExtension.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              title: Text(
                file['fileName'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Uploaded: ${file['uploadDate']} • ${file['fileSize']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.download_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      // Download file action
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Delete file action
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
