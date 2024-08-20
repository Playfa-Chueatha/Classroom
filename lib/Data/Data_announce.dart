import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/comment.dart';
import 'package:flutter_esclass_2/Data/Data_comment.dart';

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
  String datacommenttext = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: dataAnnounce.length,
        itemBuilder: (context,index){
          return Card(
            margin: EdgeInsets.all(5),
            color: Color.fromARGB(255, 152, 186, 218),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 8,
            child:Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(20,5,0,5),
                    child:Image.asset("assets/images/ครู.png",height: 50,width: 50),
                    ),      
                    Container( 
                      child: Text(" ${dataAnnounce[index].annoncetext}",style: 
                        TextStyle(
                          fontSize: 20,
                          
                        )),
                    ),                            
                  ],
                ),
                Padding(padding: 
                  EdgeInsets.fromLTRB(620, 5, 5, 5),
                  child: Row(
                    children: [ 
                      IconButton(
                        onPressed: (){
                          showDialog(
                            context: context, 
                            builder: (BuildContext context) => Comment()
                          );
                        }, 
                        icon: Icon(Icons.comment,size: 25,))
                    ],
                  ),
                )
              ],
            )
          
          );
        }),
    );
    }
  }