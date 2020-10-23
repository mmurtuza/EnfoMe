import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'instListType.dart';

class InstituteList extends StatefulWidget {
  @override
  _InstituteListState createState() => _InstituteListState();
}

class _InstituteListState extends State<InstituteList> {
  @override
  Widget build(BuildContext context) {
    return _instListWidget();
  }

  Widget _instListWidget() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: GridView.count(
        crossAxisCount: 3,
        children: [
          Card(
            child: InkWell(
              onTap: () {
                InstituteListType.typeofInst = 'university';
                Navigator.pushNamed(context, InstituteListType.routeName);
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/UNIVERSITY.png'),
                    fit: BoxFit.scaleDown,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () {
                InstituteListType.typeofInst = 'college';
                Navigator.pushNamed(context, InstituteListType.routeName);
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/COLLEGE.png'),
                    fit: BoxFit.scaleDown,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () {
                InstituteListType.typeofInst = 'corp';
                Navigator.pushNamed(context, InstituteListType.routeName);
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/CORP.png'),
                    fit: BoxFit.scaleDown,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () {
                InstituteListType.typeofInst = 'diploma';
                Navigator.pushNamed(context, InstituteListType.routeName);
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/DIPLOMA.png'),
                    fit: BoxFit.scaleDown,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () {
                InstituteListType.typeofInst = 'govt';
                Navigator.pushNamed(context, InstituteListType.routeName);
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/GOVT.png'),
                    fit: BoxFit.scaleDown,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () {
                InstituteListType.typeofInst = 'national';
                Navigator.pushNamed(context, InstituteListType.routeName);
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/NATIONAL.png'),
                    fit: BoxFit.scaleDown,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () {
                InstituteListType.typeofInst = 'private';
                Navigator.pushNamed(context, InstituteListType.routeName);
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/PRIVATE.png'),
                    fit: BoxFit.scaleDown,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () {
                InstituteListType.typeofInst = 'school';
                Navigator.pushNamed(context, InstituteListType.routeName);
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/SCHOOL.png'),
                    fit: BoxFit.scaleDown,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // _showList() {
  //   InstituteListType.typeofInst = 'school';
  //   Navigator.pushNamed(context, InstituteListType.routeName);
  // }

  // Widget _showList() {
  //   return new AlertDialog(
  //     title: const Text('About Pop up'),
  //     content: new Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         _buildAboutText(),
  //         _buildLogoAttribution(),
  //       ],
  //     ),
  //     actions: <Widget>[
  //       new FlatButton(
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //         textColor: Theme.of(context).primaryColor,
  //         child: const Text('Okay, got it!'),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildAboutText() {
    return new RichText(
      text: new TextSpan(
        text:
            'Android Popup Menu displays the menu below the anchor text if space is available otherwise above the anchor text. It disappears if you click outside the popup menu.\n\n',
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
          const TextSpan(text: 'The app was developed with '),
          new TextSpan(
            text: 'Flutter',
          ),
          const TextSpan(
            text: ' and it\'s open source; check out the source '
                'code yourself from ',
          ),
          new TextSpan(
            text: 'www.codesnippettalk.com',
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  Widget _buildLogoAttribution() {
    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: new Image.asset(
              "assets/Logo.png",
              width: 32.0,
            ),
          ),
          const Expanded(
            child: const Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: const Text(
                'Popup window is like a dialog box that gains complete focus when it appears on screen.',
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
