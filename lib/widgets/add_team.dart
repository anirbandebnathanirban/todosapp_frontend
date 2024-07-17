import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../models/team/team.dart';
import '../models/user/user.dart';
import '../provider/team_provider.dart';
import '../provider/user_provider.dart';
import '../widgets/loading.dart';

class TeamMember extends StatelessWidget {
  User teamMember;

  TeamMember({
    required this.teamMember,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
            leading: const Icon(Icons.person, color: Colors.blueAccent),
            title: Text(
                '${teamMember.userName.userFirstName} ${teamMember.userName.userLastName}',
                style: const TextStyle(color: Colors.blueAccent)),
            subtitle: Text(teamMember.userPrimaryEmail,
                style: const TextStyle(color: Colors.blueAccent)),
          );
  }
}

class AddTeam extends StatefulWidget {
  mongo.ObjectId? teamId;

  @override
  _AddTeamState createState() => _AddTeamState();
}

class _AddTeamState extends State<AddTeam> {
  Widget selectedTeam = const Text('No Team Selected',
      style: TextStyle(color: Colors.blueAccent));
  Team? team;

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Team> teams = teamProvider.teams;
    List<User> users = userProvider.users;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<Team>(
            hint: const Text('Select Team',
                style: TextStyle(color: Colors.blueAccent)),
            value: team,
            items: teams.map<DropdownMenuItem<Team>>((Team team) {
              return DropdownMenuItem<Team>(
                  value: team,
                  child: SizedBox(
                    width: 300,
                    // height: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.group, color: Colors.blueAccent),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              team.teamName,
                              style: const TextStyle(color: Colors.blueAccent),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'MEMBERS :: ${users.firstWhere((user) => user.userId == team.teamMembers[0]).userName.userFirstName}, ${users.firstWhere((user) => user.userId == team.teamMembers[1]).userName.userFirstName} ...',
                              style: const TextStyle(color: Colors.blueAccent),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ))
                      ],
                    ),
                  ));
            }).toList(),
            onChanged: (team) {
              if (team == null) {
                return;
              }
              setState(() {
                this.team = team;
                widget.teamId = team.teamId;
                selectedTeam = ExpansionTile(
                  leading: const Icon(Icons.group, color: Colors.blueAccent),
                  title: Text('name: ${team.teamName}',
                      style: const TextStyle(color: Colors.blueAccent)),
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.group, color: Colors.purpleAccent),
                      title: Text('TEAM NAME: ${team.teamName}',
                          style: const TextStyle(color: Colors.purpleAccent)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.description,
                          color: Colors.purpleAccent),
                      title: Text(
                          'TEAM DESCRIPTION: ${team.teamBasicDetails.teamDescription}',
                          style: const TextStyle(color: Colors.purpleAccent)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.date_range,
                          color: Colors.purpleAccent),
                      title: Text(
                          'TEAM CREATION DATE: ${team.teamBasicDetails.teamCreationTime.toString().split(' ')[0]}',
                          style: const TextStyle(color: Colors.purpleAccent)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.date_range,
                          color: Colors.purpleAccent),
                      title: Text(
                          'TEAM LAST MODIFICATION DATE: ${team.teamBasicDetails.teamLastModificationTime.toString().split(' ')[0]}',
                          style: const TextStyle(color: Colors.purpleAccent)),
                    ),
                    ExpansionTile(
                      leading:
                          const Icon(Icons.person, color: Colors.purpleAccent),
                      title: const Text('LEADER NAME',
                          style: TextStyle(color: Colors.purpleAccent)),
                      children: [
                        TeamMember(teamMember: users.firstWhere((user) => user.userId == team.teamLeader)),
                      ],
                    ),
                    ExpansionTile(
                      leading:
                          const Icon(Icons.group, color: Colors.purpleAccent),
                      title: const Text('TEAM MEMBERS',
                          style: TextStyle(color: Colors.purpleAccent)),
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: team.teamMembers.length,
                            itemBuilder: (context, index) {
                              return TeamMember(teamMember: users.firstWhere((user) => user.userId == team.teamMembers[index]));
                            })
                      ],
                    )
                  ],
                );
              });
            }),
        selectedTeam,
      ],
    );
  }
}
