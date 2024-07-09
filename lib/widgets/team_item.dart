import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/team/team.dart';
import '../models/user/user.dart';
import '../provider/user_provider.dart';

class TeamItem extends StatelessWidget {
  final Team team;
  final Function(Team) details;
  final ValueChanged<Team> onUpdate;

  TeamItem({
    required this.team,
    required this.details,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    userProvider.getUser(team.teamMembers[0]);
    User? member1 = userProvider.tempUser;
    userProvider.getUser(team.teamMembers[1]);
    User? member2 = userProvider.tempUser;
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          collapsedIconColor: Colors.blue,
          iconColor: Colors.greenAccent[700],
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: const Icon(Icons.group, color: Colors.blueAccent),
          title: Text(team.teamName, style: const TextStyle(color: Colors.blueAccent)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DESCRIPTION: ${team.teamBasicDetails.teamDescription}', style: const TextStyle(color: Colors.blueAccent)),
              Text('TEAM CREATION DATE: ${team.teamBasicDetails.teamCreationTime.toString().split(' ')[0]}', style: const TextStyle(color: Colors.blueAccent)),
              Text('${member1!.userName.userFirstName} ${member1.userName.userLastName}, ${member2!.userName.userFirstName} ${member2.userName.userLastName}, ...', style: const TextStyle(color: Colors.blueAccent)),
            ],
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => details(team), 
                  icon: const Icon(Icons.details, color: Colors.blueAccent),
                  label: const Text('Details', style: TextStyle(color: Colors.blueAccent)),
                ),
                TextButton.icon(
                  onPressed: () => onUpdate(team), 
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  label: const Text('Update', style: TextStyle(color: Colors.blueAccent)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}