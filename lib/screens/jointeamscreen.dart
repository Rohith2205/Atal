import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:atl_membership/controllers/UserTableController.dart';
import 'package:atl_membership/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/TeamTableService.dart';
import '../models/ModelProvider.dart';

class JoinTeamscreen extends StatefulWidget {
  const JoinTeamscreen({super.key});

  @override
  State<JoinTeamscreen> createState() => _JoinTeamscreenState();
}

class _JoinTeamscreenState extends State<JoinTeamscreen> {
  late final TextEditingController _searchController;
  late final UserController _userController;

  bool _isLoading = false;
  bool _isSearching = false;
  bool _isCheckingTeamStatus = true;
  TeamTable? _foundTeam;
  String? _errorMessage;

  // New variables to track user's team status
  bool _userHasTeam = false;
  String? _userTeamCode;
  TeamTable? _currentTeam; // Store current team info

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _userController = Get.find<UserController>();
    _checkUserTeamStatus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Check if user already has a team
  Future<void> _checkUserTeamStatus() async {
    setState(() {
      _isCheckingTeamStatus = true;
    });

    try {
      // Check if user is already in a team
      final existingTeam = await TeamTableService.getUserTeam(_userController.userId.value);

      if (existingTeam != null) {
        setState(() {
          _userHasTeam = true;
          _userTeamCode = existingTeam.team_code;
          _currentTeam = existingTeam;
        });
      } else {
        setState(() {
          _userHasTeam = false;
          _userTeamCode = null;
          _currentTeam = null;
        });
      }
    } catch (e) {
      safePrint("Error checking user team status: $e");
      // On error, assume user doesn't have a team to allow normal flow
      setState(() {
        _userHasTeam = false;
        _userTeamCode = null;
        _currentTeam = null;
      });
    } finally {
      setState(() {
        _isCheckingTeamStatus = false;
      });
    }
  }

  void _createTeam() async {
    if (_isLoading) return;

    // Check if user already has a team
    if (_userHasTeam) {
      Get.snackbar(
        "Already in Team",
        "You are already in a team with code: $_userTeamCode",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      safePrint("user id is : ${_userController.userId}");
      final String? teamCode = await TeamTableService.createTeam(_userController.userId.value);

      if (teamCode != null) {
        safePrint("team code generated is $teamCode");

        // Update user's team status
        setState(() {
          _userHasTeam = true;
          _userTeamCode = teamCode;
        });

        // Show success message
        Get.snackbar(
          "Success",
          "Team created successfully! Team code: $teamCode",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        // Navigate to team screen
        Get.toNamed('${Routes.HOME}${Routes.TEAM}');
      } else {
        setState(() {
          _errorMessage = "Failed to create team. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred while creating the team.";
      });
      safePrint("Error creating team: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchTeam() async {
    if (_isSearching) return;

    final teamCode = _searchController.text.trim();
    if (teamCode.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a team code";
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
      _foundTeam = null;
    });

    try {
      final TeamTable? team = await TeamTableService.getTeamByCode(teamCode);

      if (team != null) {
        // Check if user is already in this team
        if (team.team_members?.contains(_userController.userId.value) == true) {
          setState(() {
            _errorMessage = "You are already a member of this team";
          });
        } else if (_userHasTeam) {
          setState(() {
            _errorMessage = "You are already in a team. Leave your current team first.";
          });
        } else {
          setState(() {
            _foundTeam = team;
          });
        }
      } else {
        setState(() {
          _errorMessage = "Team not found. Please check the team code.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred while searching for the team.";
      });
      safePrint("Error searching team: $e");
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _joinTeam() async {
    if (_foundTeam == null || _isLoading) return;

    // Double check user doesn't have a team
    if (_userHasTeam) {
      Get.snackbar(
        "Already in Team",
        "You are already in a team. Leave your current team first.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bool success = await TeamTableService.joinTeam(
          _foundTeam!.team_code!,
          _userController.userId.value
      );

      if (success) {
        // Update user's team status
        setState(() {
          _userHasTeam = true;
          _userTeamCode = _foundTeam!.team_code;
          _currentTeam = _foundTeam;
        });

        // Show success message
        Get.snackbar(
          "Success",
          "Successfully joined team!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        // Navigate to team screen
        Get.toNamed('${Routes.HOME}${Routes.TEAM}');
      } else {
        setState(() {
          _errorMessage = "Failed to join team. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred while joining the team.";
      });
      safePrint("Error joining team: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showLeaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Leave Current Team",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 48),
              SizedBox(height: 16),
              Text(
                "Are you sure you want to leave the current team?",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "Team Code: ${_currentTeam?.team_code ?? 'Unknown'}",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _leaveTeam();
              },
              child: const Text(
                "Leave",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _leaveTeam() async {
    if (_currentTeam == null) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text("Leaving team..."),
          ],
        ),
      ),
    );

    try {
      final success = await TeamTableService.exitTeam(
          _currentTeam!.team_code!,
          _userController.userId.value
      );

      if (success) {
        // Update user's team status
        setState(() {
          _userHasTeam = false;
          _userTeamCode = null;
          _currentTeam = null;
        });

        Get.snackbar(
          "Success",
          "Successfully left the team",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to leave team. Please try again.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while leaving the team.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      safePrint("Error leaving team: $e");
    } finally {
      // Always close the loading dialog
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }
  }

  void _showTeamInfo() {
    if (_foundTeam == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Team Information",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Team Code: ${_foundTeam!.team_code}"),
              SizedBox(height: 8),
              Text("Members: ${_foundTeam!.team_members?.length ?? 0}"),
              if (_foundTeam!.school_name != null) ...[
                SizedBox(height: 8),
                Text("School: ${_foundTeam!.school_name}"),
              ],
              if (_foundTeam!.district != null) ...[
                SizedBox(height: 8),
                Text("District: ${_foundTeam!.district}"),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
            ElevatedButton(
              onPressed: _userHasTeam ? null : () {
                Navigator.of(context).pop();
                _joinTeam();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _userHasTeam ? Colors.grey : Colors.green,
              ),
              child: Text(
                  _userHasTeam ? "Already in Team" : "Join Team",
                  style: TextStyle(color: Colors.white)
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 40),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: _isCheckingTeamStatus
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Checking team status...'),
            ],
          ),
        )
            : SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/Emblem_of_Andhra_Pradesh.png'),
                  height: 200,
                  width: 200,
                ),

                // Show current team status if user has a team
                if (_userHasTeam)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Get.width / 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade300),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.group, color: Colors.blue, size: 32),
                        SizedBox(height: 8),
                        Text(
                          "You're already in a team!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Team Code: $_userTeamCode",
                          style: TextStyle(color: Colors.blue.shade600),
                        ),
                        SizedBox(height: 12),
                        // Leave Team Button
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _showLeaveDialog(context),
                          child: const Text(
                            'Leave Team',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Create Team Section
                Text(
                  'Create team',
                  style: TextStyle(
                      color: _userHasTeam ? Colors.grey : Colors.black,
                      fontSize: 32
                  ),
                ),
                OutlinedButton(
                  onPressed: (_isLoading || _userHasTeam) ? null : _createTeam,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _userHasTeam ? Colors.grey : Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: _isLoading
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    _userHasTeam ? 'Already in team' : 'Create new team',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                // Divider
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: Get.width / 3,
                      height: 1,
                      color: Colors.black,
                    ),
                    Text('or'),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: Get.width / 3,
                      height: 1,
                      color: Colors.black,
                    ),
                  ],
                ),

                // Find Team Section
                Text(
                  'Find a team',
                  style: TextStyle(
                      color: _userHasTeam ? Colors.grey : Colors.black,
                      fontSize: 32
                  ),
                ),

                // Search Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width / 8),
                  child: TextField(
                    controller: _searchController,
                    enabled: !_userHasTeam,
                    decoration: InputDecoration(
                      hintText: _userHasTeam
                          ? "You're already in a team"
                          : "Enter team code (e.g., ABC123456)",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: _userHasTeam ? Colors.grey : Colors.blue,
                            width: 2
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: _userHasTeam ? Colors.grey : Colors.blue,
                            width: 2
                        ),
                      ),
                      suffixIcon: _isSearching
                          ? Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                          : null,
                    ),
                    onSubmitted: _userHasTeam ? null : (_) => _searchTeam(),
                  ),
                ),

                // Search Button
                OutlinedButton(
                  onPressed: (_isSearching || _userHasTeam) ? null : _searchTeam,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _userHasTeam ? Colors.grey : Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    _userHasTeam ? 'Already in team' : 'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                // Error Message
                if (_errorMessage != null)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Get.width / 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Found Team Display
                if (_foundTeam != null && !_userHasTeam)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Get.width / 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.group, color: Colors.green, size: 24),
                            SizedBox(width: 8),
                            Text(
                              "Team Found!",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("Code: ${_foundTeam!.team_code}"),
                        Text("Members: ${_foundTeam!.team_members?.length ?? 0}"),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              onPressed: _showTeamInfo,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.blue),
                              ),
                              child: Text(
                                "View Details",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _joinTeam,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : Text(
                                "Join Team",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}