import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/pages/groups_page.dart';

class GroupsPageWrapper extends ConsumerStatefulWidget {
  const GroupsPageWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<GroupsPageWrapper> createState() => _GroupsPageWrapperState();
}

class _GroupsPageWrapperState extends ConsumerState<GroupsPageWrapper> {
  @override
  void initState() {
    super.initState();
    // Trigger groupsFutureProvider refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(groupsFutureProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const GroupsPage();
  }
}
