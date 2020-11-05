import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Widget Smallcard(String text1, icon, double sizec, String colour) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.circular(15.0),
    ),
    margin: EdgeInsets.all(15.0),
    child: Container(
      decoration: BoxDecoration(
          color: Color(hexcolor(colour)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    icon,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  Text(
                    text1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: sizec,
                        color: Colors.white),
                  ),
                ],
              ),
            ],
          )),
    ),
  );
}

hexcolor(String colour) {
  String colornew = '0xff' + colour;
  colornew = colornew.replaceAll('#', '');
  int colorproper = int.parse(colornew);
  return colorproper;
}

Widget customcard(String title, String sports, icon, String img, double sizec,
    radius, context) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.circular(radius),
    ),
    margin: EdgeInsets.all(15.0),
    child: Container(
      decoration: BoxDecoration(
        //  color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        image: DecorationImage(
          image: title != null
              ? NetworkImage(
                  title,
                )
              : AssetImage('h'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Opacity(
                opacity: 0.2,
                child: Text(
                  '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: sizec,
                      color: Colors.white),
                ),
              ),
              Opacity(
                opacity: 0.83,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 2 / 5,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(img),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Text(sports,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    ),
  );
}

Widget customcardrighttext(
    String title, var Func, icon, String img, double sizec) {
  return FlatButton(
    onPressed: () {},
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(img),
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(title),
        ],
      ),
    ),
  );
}

Widget customcardlefttext(
    String title, String sports, icon, String img, double sizec) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.circular(15.0),
    ),
    margin: EdgeInsets.all(15.0),
    child: Container(
      decoration: BoxDecoration(
        //  color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        image: DecorationImage(
          image: AssetImage(
            "assets/image/card/$img.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                icon,
                size: 30.0,
                color: Colors.black,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                    child: Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: sizec,
                            color: Colors.black)),
                  ),
                  Text(sports,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.black)),
                ],
              ),
            ],
          )),
    ),
  );
}

Widget Icontext(String title, icon) {
  return Card(
    color: Colors.white,
    //  padding: EdgeInsets.all(8.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
