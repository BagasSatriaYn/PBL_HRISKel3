import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final int employeeId;
  const ProfilePage({super.key, required this.employeeId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? employeeData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployeeData();
  }

  Future<void> fetchEmployeeData() async {
    final url = "http://localhost:8000/api/employee/${widget.employeeId}";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          employeeData = json;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : employeeData == null
              ? const Center(child: Text("Gagal memuat data"))
              : buildProfileUI(),
    );
  }

  Widget buildProfileUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // FOTO PROFIL
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage("assets/profile.jpg"),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 15),

          // NAMA
          Text(
            "${employeeData!['first_name']} ${employeeData!['last_name']}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          // position — AMBIL DARI RELASI USER
          Text(
            employeeData!["position"]?["name"] ?? "-",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 25),

          // STATISTIC DUMMY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildStatItem(Icons.timer_outlined, "180h", "Work Hours"),
              buildStatItem(Icons.local_fire_department, "3h", "Overtime"),
              buildStatItem(Icons.mail, "2", "Time Off Request"),
            ],
          ),

          const SizedBox(height: 30),

          // DETAIL PROFILE
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: DefaultTextStyle.merge(
              style: const TextStyle(fontSize: 18),
              child: Column(
                children: [
                  buildMenuItem(Icons.person, "First Name",
                      employeeData!["first_name"] ?? "-"),
                  buildMenuItem(Icons.badge, "Last Name",
                      employeeData!["last_name"] ?? "-"),
                  buildMenuItem(Icons.work, "Position",
                      employeeData!["position"]?["name"] ?? "-"),
                  buildMenuItem(Icons.apartment, "Department",
                      employeeData!["department"]?["name"] ?? "-"),
                  buildMenuItem(Icons.male, "Gender",
                      employeeData!["gender"] ?? "-"),
                  buildMenuItem(Icons.location_on, "Address",
                      employeeData!["address"] ?? "-"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // ---- WIDGET BUILDER ----
  Widget buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  Widget buildMenuItem(IconData icon, String title, String value) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.deepPurple),
          title: Text(title),
          trailing: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

