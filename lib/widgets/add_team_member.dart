import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../models/user/user.dart';
import '../provider/user_provider.dart';

class AddTeamMember extends StatefulWidget {
  mongo.ObjectId? userId;
  String placeHolder;

  AddTeamMember({
    required this.placeHolder,
  });

  @override
  _AddTeamMemberState createState() => _AddTeamMemberState();
}

class _AddTeamMemberState extends State<AddTeamMember> {
  Widget selectedUser = const Text('Nothing is selected', style: TextStyle(color: Colors.blueAccent));
  User? user;

  @override
  Widget build(BuildContext context) {
    List<User> users = Provider.of<UserProvider>(context).users;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DropdownButton<User>(
          hint: Text('Select ${widget.placeHolder}', style: const TextStyle(color: Colors.blueAccent)),
          value: user,
          items: users.map<DropdownMenuItem<User>>((User user) {
            return DropdownMenuItem<User>(
              value: user,
              child: Text('${user.userName.userFirstName} ${user.userName.userLastName}', style: const TextStyle(color: Colors.blueAccent))
            );
          }).toList(), 
          onChanged: (user) {
            setState(() {
              user = user;
              widget.userId = user!.userId;
              selectedUser = ListTile(
                leading: const Icon(Icons.person, color: Colors.blueAccent),
                title: Text('${user!.userName.userFirstName} ${user!.userName.userLastName}', style: const TextStyle(color: Colors.blueAccent)),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.email, color: Colors.blueAccent),
                    Text('EMAIL: ${user!.userPrimaryEmail}', style: const TextStyle(color: Colors.blueAccent)),
                  ],
                )
              );
            });
          }
        ),
        selectedUser,
      ],
    );
  }
}