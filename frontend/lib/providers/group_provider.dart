import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/api/group_service.dart';
import 'package:frontend/models/group_state.dart';

class GroupListNotifier extends StateNotifier<GroupListState> {
  final GroupService _groupService;

  GroupListNotifier(this._groupService)
      : super(GroupListState(memberOf: [], managerOf: []));

  // Fetch the groups and update state
  Future<void> getGroups() async {
    final groups = await _groupService.getGroups();
    state = GroupListState(
      memberOf: (groups['member_of'] as List)
          .map<Group>((json) => Group.fromJson(json as Map<String, dynamic>))
          .toList(),
      managerOf: (groups['manager_of'] as List)
          .map<Group>((json) => Group.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }

  // Create a new group
  Future<void> createGroup(String name) async {
    final success = await _groupService.createGroup(name);
    if (success) {
      await getGroups(); // Refresh the groups after creation
    }
  }

  // Delete a group
  Future<void> deleteGroup(String id) async {
    final success = await _groupService.deleteGroup(id);
    if (success) {
      state = GroupListState(
        memberOf: state.memberOf.where((group) => group.gid != id).toList(),
        managerOf: state.managerOf.where((group) => group.gid != id).toList(),
      );
    }
  }

  // Join a group
  Future<void> joinGroup(String id) async {
    final success = await _groupService.joinGroup(id);
    if (success) {
      await getGroups(); // Refresh the groups after joining
    }
  }

  // Leave a group
  Future<void> leaveGroup(String id) async {
    final success = await _groupService.leaveGroup(id);
    if (success) {
      await getGroups(); // Refresh the groups after leaving
    }
  }

  // Ban a member from a group
  Future<void> banMember(String groupId, String memberId) async {
    final success = await _groupService.banMember(groupId, memberId);
    if (success) {
      await getGroups(); // Refresh the groups after banning a member
    }
  }
}

// GroupService provider for injecting into GroupNotifier
final groupServiceProvider = Provider<GroupService>((ref) {
  return GroupService();
});

// The groupProvider to manage GroupListState using GroupNotifier
final groupListProvider =
    StateNotifierProvider<GroupListNotifier, GroupListState>((ref) {
  final groupService = ref.watch(groupServiceProvider);
  return GroupListNotifier(groupService);
});

/// ChosenGroupNotifier

class ChosenGroupNotifier extends StateNotifier<ChosenGroupState> {
  final GroupService _groupService;

  ChosenGroupNotifier(this._groupService)
      : super(ChosenGroupState(GID: "", memberList: []));

  // Set the currently selected group and load its members
  Future<void> selectGroup(String groupId) async {
    // Fetch the group details
    // Fetch the members of the group
    final members = await _groupService.getGroupMembers(groupId);

    // Map members to GroupMember instances
    final memberList = (members)
        .map<GroupMember>(
            (json) => GroupMember.fromJson(json as Map<String, dynamic>))
        .toList();

    // Update the state with selected group and its member list
    state = state.selectGroup(groupId, memberList);
  }

  // Update the member list for the selected group
  Future<void> updateMemberList(String groupId) async {
    final members = await _groupService.getGroupMembers(groupId);
    final memberList = members
        .map<GroupMember>(
            (json) => GroupMember.fromJson(json as Map<String, dynamic>))
        .toList();

    // Update the member list in the state
    state = state.updateMemberList(memberList);
  }
}

// The chosenGroupProvider to manage ChosenGroupState using ChosenGroupNotifier
final chosenGroupProvider =
    StateNotifierProvider<ChosenGroupNotifier, ChosenGroupState>((ref) {
  final groupService = ref.watch(groupServiceProvider);
  return ChosenGroupNotifier(groupService);
});
