import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupState {
  final List<String> managedGroups;
  final List<String> memberGroups;

  GroupState({
    required this.managedGroups,
    required this.memberGroups,
  });

  GroupState copyWith({
    List<String>? managedGroups,
    List<String>? memberGroups,
  }) {
    return GroupState(
      managedGroups: managedGroups ?? this.managedGroups,
      memberGroups: memberGroups ?? this.memberGroups,
    );
  }
}

class GroupNotifier extends StateNotifier<GroupState> {
  GroupNotifier() : super(GroupState(managedGroups: [], memberGroups: []));

  Future<void> loadGroupsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final managedGroups =
        prefs.getStringList('managed_groups') ?? <String>[];
    final memberGroups =
        prefs.getStringList('member_groups') ?? <String>[];

    state = state.copyWith(
      managedGroups: managedGroups,
      memberGroups: memberGroups,
    );
  }

  Future<void> createGroup(String groupName) async {
    state = state.copyWith(
      managedGroups: [...state.managedGroups, groupName],
    );
    await _saveToStorage();
  }

  Future<void> joinGroup(String groupName) async {
    state = state.copyWith(
      memberGroups: [...state.memberGroups, groupName],
    );
    await _saveToStorage();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('managed_groups', state.managedGroups);
    await prefs.setStringList('member_groups', state.memberGroups);
  }
}

final groupProvider =
    StateNotifierProvider<GroupNotifier, GroupState>((ref) {
  final notifier = GroupNotifier();
  notifier.loadGroupsFromStorage(); // Load trạng thái từ bộ nhớ khi khởi tạo
  return notifier;
});
