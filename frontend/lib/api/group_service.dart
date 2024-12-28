import 'package:dio/dio.dart';
import 'package:frontend/api/base_query.dart';

class GroupService {
  // tạo group mới
  Future<bool> createGroup(String group_name) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      Response postResponse = await baseQuery.post('/group', {
        'group_name': group_name,
      });

      if (postResponse.statusCode == 201) {
        print('Group created: ${postResponse.data}');
        return true;
      } else {
        print('Group creation failed: ${postResponse.data['message']}');
        return false;
      }
    } catch (e) {
      print('Group creation error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getGroups() async {
    try {
      BaseQuery baseQuery = BaseQuery();
      Response getResponse = await baseQuery.get('/group');

      if (getResponse.statusCode == 200) {
        print('Groups: ${getResponse.data}');
        return getResponse.data; // Return member_of and manager_of structure
      } else {
        print('Get groups failed: ${getResponse.data}');
        return {
          'member_of': [],
          'manager_of': [],
        };
      }
    } catch (e) {
      print('Get groups error: $e');
      return {
        'member_of': [],
        'manager_of': [],
      };
    }
  }

  // lấy mã mời của group
  Future<String> getGroupInviteCode(String GID) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      Response getResponse = await baseQuery.get('/group/$GID/invite');

      if (getResponse.statusCode == 200) {
        print('Group invite code: ${getResponse.data}');
        return getResponse.data['group_code'];
      } else {
        print('Get group invite code failed: ${getResponse.data['message']}');
        return '';
      }
    } catch (e) {
      print('Get group invite code error: $e');
      return '';
    }
  }

  Future<bool> joinGroup(String GID) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      Response postResponse = await baseQuery.post('/group/join/$GID', {});

      if (postResponse.statusCode == 200) {
        print('Joined group successfully: ${postResponse.data}');
        return true;
      } else {
        print('Join group failed: ${postResponse.data['message']}');
        return false;
      }
    } catch (e) {
      print('Join group error: $e');
      return false;
    }
  }

// lấy danh sách member của group
  Future<List<dynamic>> getGroupMembers(String GID) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      Response getResponse = await baseQuery.get('/group/$GID/members');

      if (getResponse.statusCode == 200) {
        print('Group members: ${getResponse.data}');
        return getResponse.data;
      } else {
        print('Get group members failed: ${getResponse.data['message']}');
        return [];
      }
    } catch (e) {
      print('Get group members error: $e');
      return [];
    }
  }

  // rời khỏi group
  Future<bool> leaveGroup(String GID) async {
    try {
      BaseQuery baseQuery = BaseQuery();

      Response postResponse = await baseQuery.post('/group/$GID/leave', {});

      if (postResponse.data['status'] == 1) {
        print('Left group: ${postResponse.data}');
        return true;
      } else {
        print('Leave group failed: ${postResponse.data['message']}');
        return false;
      }
    } catch (e) {
      print('Leave group error: $e');
      return false;
    }
  }

  // ban member
  Future<bool> banMember(String GID, String UUID) async {
    try {
      BaseQuery baseQuery = BaseQuery();

      Response postResponse =
          await baseQuery.post('/group/$GID/ban/', {'UUID': UUID});

      if (postResponse.data['status'] == 1) {
        print('Banned member: ${postResponse.data}');
        return true;
      } else {
        print('Ban member failed: ${postResponse.data['message']}');
        return false;
      }
    } catch (e) {
      print('Ban member error: $e');
      return false;
    }
  }

//delete group
  Future<bool> deleteGroup(String GID) async {
    try {
      BaseQuery baseQuery = BaseQuery();

      Response postResponse = await baseQuery.delete('/group/$GID');

      if (postResponse.statusCode == 200) {
        print('Deleted group: ${postResponse.data}');
        return true;
      } else {
        print('Delete group failed: ${postResponse.data['message']}');
        return false;
      }
    } catch (e) {
      print('Delete group error: $e');
      return false;
    }
  }
}
