import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../utils/token_storage.dart';
import '../../dashboard/screens/sidebar_employee.dart';

class EmployeeReportScreen extends StatefulWidget {
  const EmployeeReportScreen({super.key});

  @override
  State<EmployeeReportScreen> createState() => _EmployeeReportScreenState();
}

class _EmployeeReportScreenState extends State<EmployeeReportScreen> {
  String? selectedMonth;

  List<Map<String, dynamic>> absensi = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchAbsensi();
  }

  Future<void> fetchAbsensi() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception("Token tidak ditemukan, silakan login kembali");
      }

      // ✅ Pakai endpoint baru yang auto ambil dari token
      final url = Uri.parse("http://localhost:8000/api/employee/absensi/report");

      final res = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);

        setState(() {
          absensi = data.map((e) => {
                "tanggal": e["tanggal"],
                "status": e["status"],
                "masuk": e["jam_masuk"],
                "pulang": e["jam_pulang"],
                "keterangan": e["keterangan"],
              }).toList();
          loading = false;
        });
      } else {
        setState(() => loading = false);
        throw Exception("Gagal memuat data absensi: ${res.statusCode}");
      }
    } catch (e) {
      setState(() => loading = false);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    // FILTER BULAN
    final filtered = absensi.where((item) {
      if (selectedMonth == null) return true;
      return DateTime.parse(item["tanggal"])
              .month
              .toString()
              .padLeft(2, "0") ==
          selectedMonth;
    }).toList();

    final totalHadir =
        filtered.where((e) => e["status"] == "hadir").length;
    final totalTidakHadir =
        filtered.where((e) => e["status"] != "hadir").length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text(
          "Rangkuman Kehadiran",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/employee-dashboard'),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🔻 DROPDOWN FILTER BULAN
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    hint: const Text("Pilih bulan"),
                    value: selectedMonth,
                    items: List.generate(12, (index) {
                      final monthName =
                          DateFormat('MMMM').format(DateTime(2025, index + 1));
                      return DropdownMenuItem(
                        value: (index + 1).toString().padLeft(2, "0"),
                        child: Text(monthName),
                      );
                    }),
                    onChanged: (v) {
                      setState(() => selectedMonth = v);
                    },
                  ),

                  const SizedBox(height: 20),

                  // 🔻 TOTAL HADIR / TIDAK HADIR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildTotalBox("Hadir", totalHadir, Colors.green),
                      buildTotalBox("Tidak Hadir", totalTidakHadir, Colors.red),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔻 LIST ABSENSI
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(
                            child: Text(
                              "Belum ada data",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final item = filtered[index];
                              final tanggal =
                                  DateTime.parse(item["tanggal"]);
                              final isHadir = item["status"] == "hadir";

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 8),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.black12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        DateFormat("dd MMM").format(tanggal),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isHadir
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item["masuk"] ?? "-",
                                        style: TextStyle(
                                          color: isHadir
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item["pulang"] ?? "-",
                                        style: TextStyle(
                                          color: isHadir
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 90,
                                      child: Text(
                                        item["keterangan"] ?? "-",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isHadir
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
    );
  }

  // WIDGET TOTAL BOX
  Widget buildTotalBox(String title, int value, Color color) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            "$value Hari",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ), 
    );
  }
}