import 'package:flutter/material.dart';
import 'package:folk/SharedWidgets/Constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final lol;
  const ProfileListItem(
      {Key key, this.icon, this.text, this.hasNavigation = true, this.lol})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kSpacingUnit.toDouble() * 5.5,
      margin: EdgeInsets.symmetric(
        horizontal: kSpacingUnit.toDouble() * 4,
      ).copyWith(
        bottom: kSpacingUnit.toDouble() * 2,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kSpacingUnit.toDouble(),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kSpacingUnit.toDouble() * 3),
        color: Theme.of(context).backgroundColor,
      ),
      child: FlatButton(
        onPressed: lol,
        padding: EdgeInsets.all(0.0),
        child: Row(
          children: <Widget>[
            Icon(
              this.icon,
              size: kSpacingUnit.toDouble() * 2.5,
            ),
            SizedBox(width: kSpacingUnit.toDouble() * 1.5),
            Text(
              this.text,
              style: kTitleTextStyle.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(
              LineAwesomeIcons.angle_right,
              size: kSpacingUnit.toDouble() * 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
