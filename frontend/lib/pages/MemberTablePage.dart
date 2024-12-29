import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/members_table.dart';
import '../providers/group_provider.dart';

class MemberTablePage extends ConsumerWidget {
  final String groupId; // Pass the groupId for the group being displayed.
  final String role;
  const MemberTablePage({Key? key, required this.groupId, required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final chosenGroupState = ref.watch(chosenGroupProvider);
    // final notifier = ref.read(chosenGroupProvider.notifier);

    // Trigger group selection and member fetch on load
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (chosenGroupState.GID != groupId) {
    //     notifier.selectGroup(groupId);
    //   }
    // });

    // Display the member list or a loading indicator
    // final members = chosenGroupState.memberList;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(canGoBack: true),
      ),
      body:
          // chosenGroupState.GID != groupId
          //     ? const Center(child: CircularProgressIndicator())
          //     :
          Column(
        children: [
          Expanded(
            child: ResponsiveMemberTable(role: role),
          ),
        ],
      ),
      bottomNavigationBar: Footer(currentIndex: 1),
    );
  }
}
