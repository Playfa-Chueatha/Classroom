import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';


class Classroom_addwork extends StatefulWidget {
  const Classroom_addwork({super.key});

  @override
  State<Classroom_addwork> createState() => _Classroom_addworkState();
}

class _Classroom_addworkState extends State<Classroom_addwork> {

  //ตัวอย่างข้อมูล
  List<ClassroomData> allItems = [
    ClassroomData(
      Name_class: "คณิตศาสตร์",
      Section_class: "วิทยาศาสตร์-คณิตศาสตร์",
      Room_year: 4,
      Room_No: 9,
      School_year: 2567,
      Detail: " ",
    ),
    ClassroomData(
      Name_class: "ภาษาอังกฤษ",
      Section_class: "ภาษา-ศิลปะ",
      Room_year: 3,
      Room_No: 7,
      School_year: 2567,
      Detail: " ",
    ),
    // เพิ่มข้อมูลอื่นๆ ตามต้องการ
  ];

  List<ClassroomData> displayedItems = [];

  Map<ClassroomData, bool> checkedItems = {};

  @override
  void initState() {
    super.initState();
    // เริ่มต้นด้วยการแสดงผลรายการทั้งหมด
    displayedItems = List.from(allItems);
    // กำหนดค่าเริ่มต้นของ Checkbox เป็น false สำหรับทุกรายการ
    for (var item in allItems) {
      checkedItems[item] = false;
    }
  }

  // ฟังก์ชันสำหรับกรองข้อมูล
  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        // ถ้าไม่มีการค้นหา ให้แสดงรายการทั้งหมด
        displayedItems = List.from(allItems);
      } else {
        // กรองรายการที่ตรงกับคำค้นหา โดยกรองจากชื่อห้องเรียน
        displayedItems = allItems
            .where((item) =>
                item.Name_class.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _sortItems(); // เรียงรายการใหม่ทุกครั้งที่ค้นหา
    });
  }

  // ฟังก์ชันสำหรับจัดการการเปลี่ยนแปลงของ Checkbox
  void onCheckboxChanged(ClassroomData item, bool? value) {
    setState(() {
      checkedItems[item] = value ?? false;
      _sortItems(); // เรียงรายการใหม่เมื่อมีการเลือก Checkbox
    });
  }

  // ฟังก์ชันสำหรับเรียงรายการที่เลือกขึ้นไปด้านบน
  void _sortItems() {
    displayedItems.sort((a, b) {
      // เอารายการที่ถูกเลือกไว้ด้านบน
      if (checkedItems[a]! && !checkedItems[b]!) {
        return -1; // a อยู่ก่อน b
      } else if (!checkedItems[a]! && checkedItems[b]!) {
        return 1; // b อยู่ก่อน a
      } else {
        return 0; // ไม่เปลี่ยนตำแหน่ง
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.4,
      width: screenWidth * 0.2,
      child: Column(
        children: [

          // TextField ค้นหา
          
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 400, // กำหนดความกว้างตามที่ต้องการ
              height: 45, // กำหนดความสูงตามที่ต้องการ
              child: TextField(
                onChanged: filterItems,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            )
          ),

          // ListView สำหรับแสดงรายการพร้อม Checkbox
          Expanded(
            child: ListView.builder(
              itemCount: displayedItems.length,
              itemBuilder: (context, index) {
                ClassroomData currentItem = displayedItems[index];
                return ListTile(
                  title: Text(currentItem.Name_class), // ใช้ชื่อห้องเรียนแสดงใน ListTile
                  trailing: Checkbox(
                    value: checkedItems[currentItem],
                    onChanged: (value) => onCheckboxChanged(currentItem, value),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}