import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:rentors/config/app_config.dart' as config;

class SubCategoryWidget extends StatelessWidget {
  final Map item;

  SubCategoryWidget(this.item);

  Widget _acutionList(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
              color: config.Colors().white,
              child: Stack(fit: StackFit.expand, children: [
                OptimizedCacheImage(
                  imageUrl: item["icon"],
                  fit: BoxFit.contain,
                ),
                Expanded(
                    child: Container(
                  color: Colors.black87.withOpacity(0.7),
                )),
                Center(
                    child: Text(
                  item["name"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      backgroundColor: config.Colors().pink,
                      color: config.Colors().scaffoldColor,
                      fontSize: 14),
                ))
              ])

              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[

              //     Text(
              //       item["name"],
              //       style: TextStyle(
              //           color: config.Colors().scaffoldColor, fontSize: 14),
              //     )
              //   ],
              // ),
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _acutionList(context),
      width: config.App(context).appWidth(35),
    );
  }
}
