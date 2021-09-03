import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:rentors/bloc/CategoryListBloc.dart';
import 'package:rentors/config/app_config.dart' as config;
import 'package:rentors/event/CategoryListEvent.dart';
import 'package:rentors/generated/l10n.dart';
import 'package:rentors/model/category/CategoryList.dart';
import 'package:rentors/state/BaseState.dart';
import 'package:rentors/state/CategoryListState.dart';
import 'package:rentors/widget/ProgressIndicatorWidget.dart';

class CategoryScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoryScreenWidgetState();
  }
}

class CategoryScreenWidgetState extends State<CategoryScreenWidget> {
  Widget _acutionList(Category mCategory, int index) {
    final size = MediaQuery.of(context).size;
    return InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed("/category_detail", arguments: mCategory.id);
        },
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: index.isEven
                ? <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      child:
                          // SvgPicture.network(
                          //   mCategory.categoryBrand,
                          //   width: size.width * 0.6,
                          //   height: size.width * 0.6,
                          //   fit: BoxFit.fill,
                          // ),

                          OptimizedCacheImage(
                        imageUrl: mCategory.categoryBrand,
                        width: size.width * 0.6,
                        height: size.width * 0.6,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? config.Colors().color01A5DD
                            : config.Colors().pink,
                        padding: EdgeInsets.only(
                            left: 15, right: 5, top: 5, bottom: 5),
                        child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              mCategory.name.replaceAll("\n", " "),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: config.Colors().scaffoldColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900),
                            )),
                      ),
                    )
                  ]
                : <Widget>[
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 20, top: 5, bottom: 5),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? config.Colors().color01A5DD
                          : config.Colors().pink,
                      child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            mCategory.name.replaceAll("\n", " "),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: config.Colors().scaffoldColor,
                                fontSize: 25,
                                fontWeight: FontWeight.w900),
                          )),
                    )),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      child: OptimizedCacheImage(
                        imageUrl: mCategory.categoryBrand,
                        width: size.width * 0.6,
                        height: size.width * 0.6,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
          ),
        ));
  }

  CategoryListBloc mBloc = new CategoryListBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mBloc.add(CategoryListEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Image.asset(
            'assets/img/splash/logo.png',
            fit: BoxFit.fitHeight,
            height: 40,
          ),
          // Text(
          //   S.of(context).rentHire,
          //   style: TextStyle(color: Colors.white),
          // ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: BlocProvider(
            create: (BuildContext context) => CategoryListBloc(),
            child: BlocBuilder<CategoryListBloc, BaseState>(
                bloc: mBloc,
                builder: (BuildContext context, BaseState state) {
                  if (state is CategoryListState) {
                    return Container(
                        //decoration: BoxDecoration(color: Color(0xFF34424C)),
                        child: ListView.builder(
                      itemCount: state.categoryList.data.length,
                      // gridDelegate:
                      //     SliverGridDelegateWithFixedCrossAxisCount(
                      //         crossAxisCount: 1),
                      itemBuilder: (BuildContext ctxt, int index) {
                        return _acutionList(
                            state.categoryList.data[index], index);
                      },
                    ));
                  } else {
                    return ProgressIndicatorWidget();
                  }
                })));
  }
}
