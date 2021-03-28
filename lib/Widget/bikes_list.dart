import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radarsoft_ebike/Helpers/constants.dart';
import 'package:radarsoft_ebike/models/BikesParser.dart';
import 'package:radarsoft_ebike/pages/ProductDetail.dart';
import 'package:radarsoft_ebike/view%20models/bikes_view_model.dart';

// widgte for Feeds
class BikesList extends StatefulWidget {
  final List<BikesParser> bikesOBJ;

  BikesList({this.bikesOBJ});

  @override
  _BikesListState createState() => _BikesListState();
}

class _BikesListState extends State<BikesList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: widget.bikesOBJ.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Wrap(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 10),
              child: Stack(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetail(
                                    product: widget.bikesOBJ[index],
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(COLOR_BACKGROUND),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            border: Border.all(
                              color: Color(COLOR_PRIMARY),
                            ),
                          ),
                          child: Container(
                            width: screenWidth / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                      height: screenWidth / 2,
                                      fit: BoxFit.fill,
                                      imageUrl:
                                          widget.bikesOBJ[index].image_link,
                                      placeholder: (context, url) => Center(
                                        child: new CircularProgressIndicator(
                                          strokeWidth: 1,
                                          backgroundColor:
                                              Color(COLOR_BACKGROUND),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Color(COLOR_PRIMARY),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6.0, top: 8.0),
                                  child: Text(
                                    widget.bikesOBJ[index].title,
                                    style: TextStyle(
                                        color: Color(COLOR_TEXT_PRIMARY),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Plaster'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Base Fare: ',
                                        style: TextStyle(
                                            color: Color(COLOR_TEXT_PRIMARY),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Plaster'),
                                      ),
                                      Text(
                                        '\$' + widget.bikesOBJ[index].base_fare,
                                        style: TextStyle(
                                          color: Color(COLOR_TEXT_PRIMARY),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Charges: ',
                                        style: TextStyle(
                                            color: Color(COLOR_TEXT_PRIMARY),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Plaster'),
                                      ),
                                      Text('\$' +
                                          widget
                                              .bikesOBJ[index].cost_per_minute +
                                          '/min',
                                        style: TextStyle(
                                          color: Color(COLOR_TEXT_PRIMARY),
                                        ),  ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
