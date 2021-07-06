import 'package:flutter/material.dart';

class ProfessionCard extends StatelessWidget {
  final int index;
  final String image;
  final String description;
  final int professionIndex;
  final Function() onTapAction;
  const ProfessionCard({
    @required this.index,
    @required this.onTapAction,
    Key key,
    @required this.image,
    @required this.description,
    @required this.professionIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String count = "";
    String imagePath = 'assets/images/' + image + '.png';
    return GestureDetector(
      onTap: () {
        onTapAction();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8.0),
        height: 80,
        width: (professionIndex == index) ? 140 : 80,
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    image: DecorationImage(
                        image: AssetImage(image), fit: BoxFit.cover))),
            if (professionIndex == index)
              Padding(
                padding: EdgeInsets.only(),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.check_circle,
                    size: 50,
                    color: Colors.deepPurple[400].withOpacity(.8),
                  ),
                ),
              ),
            /*   Align(
                alignment:Alignment.bottomCenter,
                child:Text("Female\n25-50",style: TextStyle(
                color: Colors.white,
                fontFamily: 'Milliard',
                fontSize: 20,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 4.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 2.0,
                    color: Color.fromARGB(255, 0, 0, 2),
                  ),
                ],
                fontWeight: FontWeight.w700),))*/
          ],
        ),
      ),
    );
  }
}
