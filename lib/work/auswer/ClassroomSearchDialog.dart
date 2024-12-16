import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClassroomSearchDialog extends StatefulWidget {
  final List<Map<String, dynamic>> initialSelectedClassrooms; 
  final String username;

  const ClassroomSearchDialog({
    super.key,
    required this.initialSelectedClassrooms, 
    required this.username,
  });

  @override
  State<ClassroomSearchDialog> createState() => _ClassroomSearchDialogState();
}

class _ClassroomSearchDialogState extends State<ClassroomSearchDialog> {
  List<Map<String, dynamic>> _classroomData = [];
  List<Map<String, dynamic>> _filteredData = [];
  List<Map<String, dynamic>> _selectedClassrooms = []; 
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchClassroomData();
    _searchController.addListener(_filterData);

    
    _selectedClassrooms = List.from(widget.initialSelectedClassrooms); 
  }

  Future<void> _fetchClassroomData() async {
  final url = Uri.parse('https://www.edueliteroom.com/connect/searchClassrooms_forasign.php?username=${widget.username}');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          _classroomData = List<Map<String, dynamic>>.from(data['classrooms']);
          _filteredData = _classroomData;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
  }
}


  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = _classroomData.where((classroom) {
        return classroom['classroom_name'].toString().toLowerCase().contains(query) ||
            classroom['classroom_major'].toString().toLowerCase().contains(query) ||
            classroom['classroom_year'].toString().toLowerCase().contains(query) ||
            classroom['classroom_numroom'].toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  void _toggleSelection(Map<String, dynamic> classroom) {
    setState(() {
      if (_selectedClassrooms.contains(classroom)) {
        _selectedClassrooms.remove(classroom);
      } else {
        _selectedClassrooms.add(classroom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('เลือกห้องเรียน'),
      content: SizedBox(
        width: 1000,
        height: 700,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'ค้นหาห้องเรียน',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: _filteredData.isEmpty
                  ? const Center(child: Text('ไม่มีข้อมูลที่จะแสดง'))
                  : ListView.builder(
                      itemCount: _filteredData.length,
                      itemBuilder: (context, index) {
                        final classroom = _filteredData[index];
                        final isSelected = _selectedClassrooms.contains(classroom);
                        final isInitialSelected = widget.initialSelectedClassrooms.any(
                            (selectedClassroom) =>
                                selectedClassroom['classroom_name'] == classroom['classroom_name'] &&
                                selectedClassroom['classroom_major'] == classroom['classroom_major'] &&
                                selectedClassroom['classroom_year'] == classroom['classroom_year'] &&
                                selectedClassroom['classroom_numroom'] == classroom['classroom_numroom']);

                        return ListTile(
                          leading: isInitialSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    _toggleSelection(classroom);
                                  },
                                ),
                          title: Text(classroom['classroom_name']),
                          subtitle: Text(
                              'สาขา: ${classroom['classroom_major']} - ปี: ${classroom['classroom_year']} - ห้อง: ${classroom['classroom_numroom']}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ปิด'),
        ),
        TextButton(
          onPressed: () {
            // กรองห้องเรียนที่มี `check_circle` ออกจาก `_selectedClassrooms`
            final filteredClassrooms = _selectedClassrooms.where((classroom) {
              return !widget.initialSelectedClassrooms.any(
                (selectedClassroom) =>
                    selectedClassroom['classroom_name'] == classroom['classroom_name'] &&
                    selectedClassroom['classroom_major'] == classroom['classroom_major'] &&
                    selectedClassroom['classroom_year'] == classroom['classroom_year'] &&
                    selectedClassroom['classroom_numroom'] == classroom['classroom_numroom'],
              );
            }).toList();

            // ส่งข้อมูลที่เลือกกลับไปยังหน้าหลัก
            Navigator.of(context).pop(filteredClassrooms);
          },
          child: const Text('ยืนยัน'),
        ),
      ],
    );
  }
}
