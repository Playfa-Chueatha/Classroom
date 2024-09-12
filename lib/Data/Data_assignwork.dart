//---------------------Data_assignwork_auswerq------------------------------------------------------------

class auswerq{
  final String directionauswerq;
  final int fullMarksauswerq;
  final String dueDateauswerq;
  final List<String> filesauswerq;
  final List<String> linksauswerq;

  auswerq({
    required this.directionauswerq,
    required this.fullMarksauswerq,
    required this.dueDateauswerq,
    required this.filesauswerq,
    required this.linksauswerq,
  });

  
}

List<auswerq> datauswerq = [
  auswerq(
    directionauswerq: 'ให้นักเรียนแนะนำตัวอย่างน้อย 3 บรรทัด', 
    fullMarksauswerq: 30, 
    dueDateauswerq: '17 Sep 2024', 
    filesauswerq: ['file1.pdf', 'file2.docx'], 
    linksauswerq: ['https://example.com/link1', 'https://example.com/link2'],
  )
];

//---------------------Data_assignwork_upfile------------------------------------------------------------
class upfile {
  final String directionupfile;
  final int fullMarksupfile;
  final String dueDateupfile;
  final List<String> filesupfile;
  final List<String> linksupfile;

  upfile({
    required this.directionupfile,
    required this.fullMarksupfile,
    required this.dueDateupfile,
    required this.filesupfile,
    required this.linksupfile
  });

}

//------------------Data_onechoice--------------------------------------------------------------------------------

class OneChoice {
  final String directionone;
  final int fullMarkone;
  final String dueDateone;


  OneChoice({
    required this.directionone,
    required this.fullMarkone,
    required this.dueDateone
  });
}

//----------------Data_manychoice-------------------------------------------------------------------------------

class Manychoice {
  final String directionmany;
  final int fullMarkmany;
  final String dueDatemany;

  Manychoice({
    required this.directionmany,
    required this.fullMarkmany,
    required this.dueDatemany
  });
}