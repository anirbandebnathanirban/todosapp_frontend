import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../models/team/team.dart';
import '../provider/team_provider.dart';
import '../provider/user_provider.dart';
import '../widgets/loading.dart';

class TeamMember extends StatelessWidget {
  mongo.ObjectId teamMemberId;

  TeamMember({
    required this.teamMemberId,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    userProvider.getUser(teamMemberId);
    return userProvider.isLoading ? 
    const Loading() : 
    ListTile(
      leading: const Icon(Icons.person, color: Colors.blueAccent),
      title: Text('${userProvider.tempUser!.userName.userFirstName} ${userProvider.tempUser!.userName.userLastName}', style: const TextStyle(color: Colors.blueAccent)),
      subtitle: Text('${userProvider.tempUser!.userPrimaryEmail}', style: const TextStyle(color: Colors.blueAccent)),
    );
  }
}

class AddTeam extends StatefulWidget {
   
  mongo.ObjectId? teamId;

  @override
  _AddTeamState createState() => _AddTeamState();
}

class _AddTeamState extends State<AddTeam> {
  Widget selectedTeam = const Text('No Team Selected', style: TextStyle(color: Colors.blueAccent));
  Team? team;

  Widget build(BuildContext context) {
    List<Team> teams = Provider.of<TeamProvider>(context).teams; 
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DropdownButton<Team>(
          hint: Text('Select Team', style: TextStyle(color: Colors.blueAccent)),
          value: team,
          items: teams.map<DropdownMenuItem<Team>>((Team team) {
            return DropdownMenuItem<Team>(
              value: team,
              child: ExpansionTile(
                leading: const Icon(Icons.group, color: Colors.blueAccent),
                title: Text(team.teamName, style: const TextStyle(color: Colors.blueAccent)),
                children: [
                  ListView.builder(
                    itemCount: team.teamMembers.length,
                    itemBuilder: (context, index) {
                      return TeamMember(teamMemberId: team.teamMembers[index]);
                    }
                  )
                ],
              )
            );
          }).toList(), 
          onChanged: (team) {
            setState(() {
              team = team;
              widget.teamId = team!.teamId;
              selectedTeam = ExpansionTile(
                leading: const Icon(Icons.group, color: Colors.blueAccent),
                title: Text('name: ${team!.teamName}', style: const TextStyle(color: Colors.blueAccent)),
                children: [
                  ListTile(
                    leading: const Icon(Icons.group, color: Colors.purpleAccent),
                    title: Text('TEAM NAME: ${team!.teamName}', style: const TextStyle(color: Colors.purpleAccent)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.description, color: Colors.purpleAccent),
                    title: Text('TEAM DESCRIPTION: ${team!.teamBasicDetails.teamDescription}', style: const TextStyle(color: Colors.purpleAccent)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.date_range, color: Colors.purpleAccent),
                    title: Text('TEAM CREATION DATE: ${team!.teamBasicDetails.teamCreationTime.toString().split(' ')[0]}', style: const TextStyle(color: Colors.purpleAccent)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.date_range, color: Colors.purpleAccent),
                    title: Text('TEAM LAST MODIFICATION DATE: ${team!.teamBasicDetails.teamLastModificationTime.toString().split(' ')[0]}', style: const TextStyle(color: Colors.purpleAccent)),
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.person, color: Colors.purpleAccent),
                    title: const Text('LEADER NAME', style: TextStyle(color: Colors.purpleAccent)),
                    children: [
                      TeamMember(teamMemberId: team!.teamLeader),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.group, color: Colors.purpleAccent),
                    title: const Text('TEAM MEMBERS', style: TextStyle(color: Colors.purpleAccent)),
                    children: [
                      ListView.builder(
                        itemCount: team!.teamMembers.length,
                        itemBuilder: (context, index) {
                          return TeamMember(teamMemberId: team!.teamMembers[index]);
                        }
                      )
                    ],
                  )
                ],
              );
            });
          }
        )
      ],
    );
  }
}