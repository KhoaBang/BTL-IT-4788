class Group {
  final String gid;
  final String groupName;

  Group({required this.gid, required this.groupName});

  // Factory method for creating a Group instance from JSON
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      gid: json['GID'],
      groupName: json['group_name'],
    );
  }

  // Method for converting a Group instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'GID': gid,
      'group_name': groupName,
    };
  }
}

class GroupListState {
  List<Group> memberOf = [];
  List<Group> managerOf = [];
  final bool isLoading;

  GroupListState(
      {required this.memberOf,
      required this.managerOf,
      this.isLoading = false});

  // Factory method for creating a GroupListState instance from JSON
  factory GroupListState.fromJson(Map<String, dynamic> json) {
    return GroupListState(
      memberOf: (json['member_of'] as List<dynamic>)
          .map((item) => Group.fromJson(item as Map<String, dynamic>))
          .toList(),
      managerOf: (json['manager_of'] as List<dynamic>)
          .map((item) => Group.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method for converting a GroupListState instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'member_of': memberOf.map((group) => group.toJson()).toList(),
      'manager_of': managerOf.map((group) => group.toJson()).toList(),
    };
  }
}

class GroupMember {
  final String uuid;
  final String email;
  final String username;

  GroupMember(
      {required this.uuid, required this.email, required this.username});

  // Factory method for creating a GroupMember instance from JSON
  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      uuid: json['UUID'],
      email: json['email'],
      username: json['username'],
    );
  }

  // Method for converting a GroupMember instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'UUID': uuid,
      'email': email,
      'username': username,
    };
  }
}

class ChosenGroupState {
  final String? GID;
  final List<GroupMember> memberList;

  ChosenGroupState({
    this.GID,
    this.memberList = const [],
  });

  // Set the selected group and its members, along with the role
  ChosenGroupState selectGroup(String GID, List<GroupMember> members) {
    return ChosenGroupState(
      GID: GID,
      memberList: members,
    );
  }

  // Update the member list for the selected group
  ChosenGroupState updateMemberList(List<GroupMember> members) {
    return ChosenGroupState(
      GID: GID,
      memberList: members,
    );
  }
}
