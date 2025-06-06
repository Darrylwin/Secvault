import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FileCard extends StatelessWidget {
  const FileCard({
    super.key,
    required this.fileExtension,
    required this.fileName,
    required this.uploadedAt,
    required this.onDownloadPressed,
    required this.onDeletePressed,
    required this.onFileCardTapped,
  });

  final String fileExtension;
  final String fileName;
  final DateTime uploadedAt;
  final VoidCallback onDownloadPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onFileCardTapped;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onFileCardTapped,
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
              fileName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Uploaded on ${DateFormat('MMM dd, yyyy').format(uploadedAt)}',
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
                  onPressed: onDownloadPressed,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.grey,
                  ),
                  onPressed: onDeletePressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
