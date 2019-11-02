import 'package:chatto/models/stadistic-model.dart';
import 'package:flutter/material.dart';

class ProfileStadistics extends StatefulWidget {
  @override
  _ProfileStadisticsState createState() => _ProfileStadisticsState();
}

class _ProfileStadisticsState extends State<ProfileStadistics> {

  final double totalWidth = 0.88;
  final double parentMargin = 0.05;
  final double childMargin = 0.015;

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width * totalWidth,
      margin: EdgeInsets.symmetric(
        vertical: 40,
        horizontal: MediaQuery.of(context).size.width * parentMargin
      ),
      child: ListView.builder(
        itemCount: stadistics.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final Stadistic stadistic = stadistics[index];
          bool selected = (selectedIndex == index);
          Color selectedColor = selected  ? Colors.white : Colors.black;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Tooltip(
              message: stadistic.name,
              child: Container(
                width: MediaQuery.of(context).size.width * ((totalWidth / stadistics.length) - (childMargin * 2)),
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * childMargin),
                decoration: BoxDecoration(
                  color: selected
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                  boxShadow: selected
                  ? [
                    BoxShadow(
                      color: Theme.of(context).primaryColor,
                      blurRadius: 50,
                      spreadRadius: -10,
                      offset: Offset(0.0, 25.0)
                    )
                  ]
                  : []
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      stadistic.icon,
                      color: selectedColor
                    ),
                    SizedBox(height: 10),
                    Text(
                      stadistic.count.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GilroyBold',
                        color: selectedColor
                      )
                    )
                  ]
                )
              )
            )
          );
        }
      )
    );
  }
}