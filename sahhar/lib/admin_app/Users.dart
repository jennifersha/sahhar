import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream;
  TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _usersStream = _firestore.collection('users').snapshots();
  }

  Future<void> _removeUserAccount(String userId, String email) async {
    try {
      // Remove user from the 'users' collection in Firestore
      await _firestore.collection('users').doc(userId).delete();

      // Remove user from Firebase Authentication
      User? user = _auth.currentUser;
      if (user != null && user.email == email) {
        // Delete user from Firebase Authentication
        await user.delete();

        // Show a success message or perform any other actions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User account removed successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Show an error message if the user is not found or doesn't match the email
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to remove user account: User not found or email mismatch'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      // Show an error message or perform any error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove user account'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>? _snapshot;

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: const Color(0xFF7E0000),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _filteredUsers = _snapshot!.data!.docs.where((user) {
                    final userData = user.data();
                    final firstName = userData['Firstname'] ?? '';
                    final lastName = userData['Lastname'] ?? '';
                    final email = userData['email'] ?? '';
                    final phoneNumber = userData['phoneNumber'] ?? '';

                    final query = value.toLowerCase();

                    return firstName.toLowerCase().contains(query) ||
                        lastName.toLowerCase().contains(query) ||
                        email.toLowerCase().contains(query) ||
                        phoneNumber.toLowerCase().contains(query);
                  }).toList();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _usersStream,
              builder: (context, snapshot) {
                _snapshot = snapshot; // Assigning the snapshot

                if (snapshot.hasData) {
                  final users = _filteredUsers.isNotEmpty
                      ? _filteredUsers
                      : snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final userData = users[index].data();
                      final userId = users[index].id;
                      final firstName = userData['Firstname'];
                      final lastName = userData['Lastname'];
                      final email = userData['email'];
                      final phoneNumber = userData['phoneNumber'];

                      return Card(
                        elevation: 2,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: const Color(0xFF7E0000),
                          ),
                          title: Text(
                            '$firstName $lastName',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email: $email',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Phone Number: $phoneNumber',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.cancel_outlined,
                                color: const Color(0xFF7E0000)),
                            onPressed: () => _removeUserAccount(userId, email),
                          ),
                          tileColor: Colors.white,
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
