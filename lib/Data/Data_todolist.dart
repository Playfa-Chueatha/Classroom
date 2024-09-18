//Model todolist
class Todoclass {
  Todoclass({required this.Title, required this.Detail, this.isDone = false});
  String Title;
  String Detail;
  bool isDone;

  void toggleDone() {
    isDone = !isDone;
  }
}

List<Todoclass> data = [
  Todoclass(
    Title: "ทำโปรเจค",
    Detail: "ทำหน้าสร้างห้อง",
  ),
];
