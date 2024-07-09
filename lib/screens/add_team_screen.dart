import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../models/team/team.dart';
import '../models/team/team_basic_details.dart';
import '../provider/team_provider.dart';
import '../provider/auth_provider.dart';
import '../widgets/add_team_member.dart';

class AddTeamScreen extends StatefulWidget {
  @override
  _AddTeamScreenState createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends State<AddTeamScreen> {
  String teamName = '';
  String teamDescription = '';

  List<AddTeamMember> teamMembersFormList = [
    AddTeamMember(placeHolder: 'Team Member'),
    AddTeamMember(placeHolder: 'Team Member')
  ];
  List<mongo.ObjectId> teamMembers = [];

  AddTeamMember teamLeaderForm =
      AddTeamMember(placeHolder: 'Team Leader(By default you)');
  mongo.ObjectId? teamLeader;

  void _addTeam(BuildContext context) {
    if (teamName.isEmpty || teamDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both Team Name and Description'),
        ),
      );
    } else if (teamMembers.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Atleast 2 Team Members are required'),
        ),
      );
    } else {
      Provider.of<TeamProvider>(context).createTeam(Team(
        teamName: teamName,
        teamBasicDetails: Teambasicdetails(
            teamDescription: teamDescription,
            teamCreationTime: DateTime.now(),
            teamLastModificationTime: DateTime.now()),
        teamMembers: teamMembers,
        teamLeader: teamLeader!,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Team'),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          TextFormField(
            onChanged: (value) {
              teamName = value;
            },
            controller: TextEditingController(text: teamName),
            decoration: const InputDecoration(
              icon: Icon(Icons.group, color: Colors.blueAccent),
              label:
                  Text('Team Name', style: TextStyle(color: Colors.blueAccent)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Team Name id required';
              }
              return null;
            },
          ),
          TextFormField(
            onChanged: (value) {
              teamDescription = value;
            },
            controller: TextEditingController(text: teamDescription),
            decoration: const InputDecoration(
              icon: Icon(Icons.description, color: Colors.blueAccent),
              label: Text('Team Description',
                  style: TextStyle(color: Colors.blueAccent)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Team Description is required';
              }
              return null;
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    teamMembersFormList
                        .add(AddTeamMember(placeHolder: 'Team Member'));
                  });
                },
                icon: const Icon(Icons.person_add, color: Colors.blueAccent),
                label: const Text('Add Team Member',
                    style: TextStyle(color: Colors.blueAccent)),
              ),
              ListView.builder(
                  itemCount: teamMembersFormList.length,
                  itemBuilder: (context, index) {
                    return teamMembersFormList[index];
                  })
            ],
          ),
          teamLeaderForm,
          TextButton.icon(
              onPressed: () {
                for (AddTeamMember teamMember in teamMembersFormList) {
                  if (teamMember.userId != null) {
                    teamMembers.add(teamMember.userId!);
                  }
                }
                if (teamLeaderForm.userId != null) {
                  teamLeader = teamLeaderForm.userId;
                } else {
                  teamLeader = Provider.of<AuthProvider>(context).userId;
                }
                _addTeam(context);
              },
              icon: const Icon(Icons.add_box, color: Colors.blueAccent),
              label: const Text('Create Team',
                  style: TextStyle(color: Colors.blueAccent)))
        ],
      ),
    );
  }
}
