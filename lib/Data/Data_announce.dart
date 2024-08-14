import 'package:flutter/material.dart';

class DataAnnounce {
  DataAnnounce({
    required this.annoncetext,
  });
  String annoncetext;

  static void add(DataAnnounce dataAnnounce) {}
}
List<DataAnnounce> dataAnnounce =[
  DataAnnounce(
    annoncetext: 'ทำงานด้วยนะคะทุกคน')
];

class announce extends StatefulWidget {
  const announce({super.key});

  @override
  State<announce> createState() => announceState();
}

class announceState extends State<announce> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 700,
      margin: EdgeInsets.all(5),
      child: ListView.builder(
        itemCount: dataAnnounce.length,
        itemBuilder: (context,index){
          return Container(
            height: 60,
            width: 500,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 152, 186, 218),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              children: [
                Image.asset("assets/images/ครู.png",height: 50,width: 50),
                Container( 
                  child: Text(" ${dataAnnounce[index].annoncetext}",style: TextStyle(fontSize: 20)),
                ),             
              ],
            ),
          );
        }),
    );


  }
}
