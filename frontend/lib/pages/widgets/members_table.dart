import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/group_provider.dart';
import 'confirmation_dialog.dart';

class ResponsiveMemberTable extends ConsumerWidget {
  final String role;
  const ResponsiveMemberTable({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosenGroupState = ref.watch(chosenGroupProvider);
    final groupNotifier = ref.read(chosenGroupProvider.notifier);
    final groupId = chosenGroupState.GID;
    final members = chosenGroupState.memberList;

    // Ban member
    Future<void> _banMember(String memberID) async {
      try {
        if (groupId != null) {
          await groupNotifier.banMember(groupId, memberID);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Member banned successfully!')),
          );
        } else {
          throw Exception("Group ID is null");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to ban member: $e')),
        );
      }
    }

    if (members.isEmpty) {
      return const Center(
        child: Text(
          'No members found for this group.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = constraints.maxWidth;

        return Container(
          color: const Color.fromARGB(255, 255, 228, 188),
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: tableWidth,
              ),
              child: DataTable(
                columnSpacing: 20,
                columns: <DataColumn>[
                  const DataColumn(
                    label: Text(
                      'Member',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (role ==
                      'manager') // Only show the "Option" column if role is 'manager'
                    const DataColumn(
                      label: Text(
                        'Option',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
                rows: members.map((member) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.username,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              member.email,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (role ==
                          'manager') // Show the option button only if role is 'manager'
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Remove',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return ConfirmDialog(
                                    title: 'Ban Member',
                                    content:
                                        'Are you sure you want to ban this member?',
                                    confirmText: 'Confirm',
                                    cancelText: 'Cancel',
                                    onConfirm: () => {_banMember(member.uuid)},
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
