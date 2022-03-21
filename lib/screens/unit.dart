import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_finder/imports.dart';

class UnitScreen extends StatefulWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/unit?id=${unit.id}',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  const UnitScreen({
    Key? key,
    required this.unit,
  }) : super(key: key);

  final UnitModel unit;

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  @override
  Widget build(BuildContext context) {
    var unit = widget.unit;
    var width = MediaQuery.of(context).size.width;

    // Theme.of(context).textTheme.caption;
    // var captionTextStyle = Theme.of(context).textTheme.caption;
    // Theme.of(context).textTheme.caption!.getTextStyle();
    // var style = Theme.of(context).textTheme.headline6;
    // Theme.of(context).appBarTheme.toolbarTextStyle;
    // out(style);
    return Scaffold(
      // backgroundColor: Theme.of(context).dialogBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        // iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_horiz),
          ),
        ],

        // title: Column(
        //   // crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       children: [
        //         Icon(
        //           unit.sex == Sex.male ? Icons.male : Icons.female,
        //           color: Colors.white,
        //         ),
        //         Text(
        //           formatAge(unit),
        //           style: Theme.of(context).textTheme.titleLarge!.copyWith(
        //                 color: Colors.white,
        //               ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        // actions: [
        //   IconButton(
        //     tooltip: "Profile",
        //     icon: Icon(Platform.isIOS
        //         ? CupertinoIcons.person_crop_circle_fill
        //         : Icons.account_box),
        //     onPressed: () {
        //       navigator.push(ProfileScreen().getRoute());
        //     },
        //   ),
        // ],

        // RichText(
        //   text: TextSpan(
        //     text: 'Hello ',
        //     style: Theme.of(context).textTheme.titleLarge,
        //     // DefaultTextStyle.of(context).style,
        //     // children: const <TextSpan>[
        //     //   TextSpan(
        //     //       text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
        //     //   TextSpan(text: ' world!'),
        //     // ],
        //   ),
        // ),
      ),
      // body: Center(child: Text('(${widget.unit.id})')));

      // FIXED: Scaffold.extendBodyBehindAppBar https://github.com/flutter/flutter/issues/14842
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: width,
              child: Stack(
                children: [
                  Hero(
                    tag: unit.imageUrl,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: getImageProvider(unit.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        // borderRadius: BorderRadius.only(
                        //   bottomLeft: Radius.circular(25),
                        //   bottomRight: Radius.circular(25),
                        // ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   left: 0,
                  //   child: _buildBadge(),
                  // ),

                  // Container(
                  //   width: width, // TODO: убрать костыль
                  //   height: 150,
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       begin: FractionalOffset.topCenter,
                  //       end: FractionalOffset.bottomCenter,
                  //       colors: <Color>[
                  //         Colors.black.withOpacity(0.4),
                  //         Colors.grey.withOpacity(0.0),
                  //       ],
                  //     ),
                  //   ),
                  //   // child: Container(
                  //   //   padding: const EdgeInsets.all(36.0),
                  //   //   alignment: Alignment.topLeft,
                  //   //   // child:

                  //   //   // Center(child: Text("1111")),
                  //   // ),
                  // ),
                ],
              ),
            ),
            _buildBottom(),
            _buildTitle(),
            // TODO: при скроллинге elevation сверху и градиент снизу
            Expanded(
              child: Scrollbar(
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    child: Text(
                        "Цвет Рыжий. Lorem ipsum dolor sit amet consectetur adipisicing elit. Adipisci eos obcaecati molestiae ipsam doloremque consequuntur, in, incidunt quos voluptas quaerat placeat, laboriosam aliquam! Doloremque repudiandae tempora esse sed dolorum culpa, blanditiis quisquam aspernatur laboriosam, officia facere saepe qui. Eaque at autem porro quibusdam omnis? Nulla sit aliquid quia earum optio asperiores ipsum mollitia magnam tempora, error cumque. Quisquam, provident veritatis maiores autem illo, minus qui facilis ea quasi nobis voluptatibus, reiciendis temporibus! Dolore placeat repudiandae aliquam ullam neque numquam nostrum commodi cupiditate ex ad ratione est natus obcaecati enim iusto maiores dolorum labore itaque officia, maxime perspiciatis. Veniam numquam dicta hic ad ipsam quisquam cupiditate voluptatibus nesciunt atque praesentium, porro sunt debitis, quidem id et dolore quod perspiciatis eveniet consequuntur iste. Esse amet tempora commodi laudantium mollitia distinctio accusantium quos saepe quia ad eaque, error est ut voluptatem ipsa. Voluptatem rerum iusto quidem consectetur ipsum? Possimus nihil optio, quasi fugit commodi veniam? Dolore voluptas asperiores laboriosam repudiandae? Deserunt, perspiciatis. Dolor repellat reprehenderit maxime veritatis, repellendus provident amet quis autem officiis architecto doloremque numquam quas assumenda aliquam, facere illum culpa cumque maiores beatae. Rem tenetur aliquam ex repellendus, incidunt laboriosam, eligendi vitae ducimus, recusandae ullam et? Ipsum minus autem, expedita ex recusandae consequuntur reprehenderit, in, rem eos rerum adipisci tempora consequatur necessitatibus natus sapiente ut deleniti accusamus. Sequi dicta distinctio quas, dolorum aliquam saepe placeat rem amet at odit repellat numquam tenetur consequatur consequuntur cumque, soluta repudiandae rerum sit. Non, saepe. Officiis, laudantium id? Architecto numquam non recusandae consequuntur ipsum deleniti unde, adipisci iusto explicabo accusamus ipsa suscipit porro hic accusantium, blanditiis, at voluptas? Culpa aliquam quod reprehenderit repellat recusandae? Sapiente maxime rerum debitis rem aliquam perferendis distinctio unde aspernatur ea voluptatibus iste aliquid, tenetur perspiciatis dolorem impedit sint cum soluta, laborum suscipit incidunt libero repellat. Earum temporibus accusamus accusantium iure cupiditate odit adipisci, beatae quaerat repellat asperiores commodi aliquid cum autem eos recusandae aspernatur non praesentium ipsum at tempora ducimus, esse aperiam? Ad deserunt a, impedit quae aliquid voluptates, quaerat illo facilis suscipit, ratione earum? Eveniet tenetur, quod distinctio, cupiditate incidunt provident temporibus voluptas neque impedit odio asperiores minima eligendi. Consequatur ipsum distinctio repellat excepturi optio quos iste est asperiores maiores error iusto praesentium obcaecati, blanditiis tempora amet consectetur ab debitis molestias magnam ut iure unde deserunt deleniti qui! Dolorem blanditiis ab reiciendis odit quidem rerum dignissimos rem quaerat ipsum! Doloribus, repudiandae! Non fuga numquam sequi qui obcaecati, provident culpa minima dolore commodi temporibus ratione pariatur. Quod fuga corporis voluptatibus aliquam voluptatem odit, praesentium molestias voluptate animi numquam magni nemo dolorum illo? Natus voluptatibus blanditiis, optio ipsa praesentium quia adipisci nesciunt corporis. Similique fugit, atque quo voluptatibus iste odit ex iusto. Cupiditate quas omnis quisquam odit, ex nostrum cum libero molestias accusamus. Vitae doloribus voluptate eos beatae voluptatem modi unde reprehenderit? Ut porro explicabo dolorem reprehenderit ipsam suscipit ipsum quibusdam voluptatibus iusto, repellendus itaque voluptate vitae et corporis quisquam unde quis? Adipisci nostrum nobis fugiat sunt molestiae nisi ea unde suscipit officiis illum, quo, possimus facilis culpa fugit vero nesciunt."),
                  ),
                ),
              ),
              // Container(color: Colors.red),
            ),
            // Expanded(
            //   child: TextField(
            //     maxLines: null,
            //     controller: TextEditingController(
            //         text:
            //             "Lorem ipsum dolor sit amet consectetur adipisicing elit. Adipisci eos obcaecati molestiae ipsam doloremque consequuntur, in, incidunt quos voluptas quaerat placeat, laboriosam aliquam! Doloremque repudiandae tempora esse sed dolorum culpa, blanditiis quisquam aspernatur laboriosam, officia facere saepe qui. Eaque at autem porro quibusdam omnis? Nulla sit aliquid quia earum optio asperiores ipsum mollitia magnam tempora, error cumque. Quisquam, provident veritatis maiores autem illo, minus qui facilis ea quasi nobis voluptatibus, reiciendis temporibus! Dolore placeat repudiandae aliquam ullam neque numquam nostrum commodi cupiditate ex ad ratione est natus obcaecati enim iusto maiores dolorum labore itaque officia, maxime perspiciatis. Veniam numquam dicta hic ad ipsam quisquam cupiditate voluptatibus nesciunt atque praesentium, porro sunt debitis, quidem id et dolore quod perspiciatis eveniet consequuntur iste. Esse amet tempora commodi laudantium mollitia distinctio accusantium quos saepe quia ad eaque, error est ut voluptatem ipsa. Voluptatem rerum iusto quidem consectetur ipsum? Possimus nihil optio, quasi fugit commodi veniam? Dolore voluptas asperiores laboriosam repudiandae? Deserunt, perspiciatis. Dolor repellat reprehenderit maxime veritatis, repellendus provident amet quis autem officiis architecto doloremque numquam quas assumenda aliquam, facere illum culpa cumque maiores beatae. Rem tenetur aliquam ex repellendus, incidunt laboriosam, eligendi vitae ducimus, recusandae ullam et? Ipsum minus autem, expedita ex recusandae consequuntur reprehenderit, in, rem eos rerum adipisci tempora consequatur necessitatibus natus sapiente ut deleniti accusamus. Sequi dicta distinctio quas, dolorum aliquam saepe placeat rem amet at odit repellat numquam tenetur consequatur consequuntur cumque, soluta repudiandae rerum sit. Non, saepe. Officiis, laudantium id? Architecto numquam non recusandae consequuntur ipsum deleniti unde, adipisci iusto explicabo accusamus ipsa suscipit porro hic accusantium, blanditiis, at voluptas? Culpa aliquam quod reprehenderit repellat recusandae? Sapiente maxime rerum debitis rem aliquam perferendis distinctio unde aspernatur ea voluptatibus iste aliquid, tenetur perspiciatis dolorem impedit sint cum soluta, laborum suscipit incidunt libero repellat. Earum temporibus accusamus accusantium iure cupiditate odit adipisci, beatae quaerat repellat asperiores commodi aliquid cum autem eos recusandae aspernatur non praesentium ipsum at tempora ducimus, esse aperiam? Ad deserunt a, impedit quae aliquid voluptates, quaerat illo facilis suscipit, ratione earum? Eveniet tenetur, quod distinctio, cupiditate incidunt provident temporibus voluptas neque impedit odio asperiores minima eligendi. Consequatur ipsum distinctio repellat excepturi optio quos iste est asperiores maiores error iusto praesentium obcaecati, blanditiis tempora amet consectetur ab debitis molestias magnam ut iure unde deserunt deleniti qui! Dolorem blanditiis ab reiciendis odit quidem rerum dignissimos rem quaerat ipsum! Doloribus, repudiandae! Non fuga numquam sequi qui obcaecati, provident culpa minima dolore commodi temporibus ratione pariatur. Quod fuga corporis voluptatibus aliquam voluptatem odit, praesentium molestias voluptate animi numquam magni nemo dolorum illo? Natus voluptatibus blanditiis, optio ipsa praesentium quia adipisci nesciunt corporis. Similique fugit, atque quo voluptatibus iste odit ex iusto. Cupiditate quas omnis quisquam odit, ex nostrum cum libero molestias accusamus. Vitae doloribus voluptate eos beatae voluptatem modi unde reprehenderit? Ut porro explicabo dolorem reprehenderit ipsam suscipit ipsum quibusdam voluptatibus iusto, repellendus itaque voluptate vitae et corporis quisquam unde quis? Adipisci nostrum nobis fugiat sunt molestiae nisi ea unde suscipit officiis illum, quo, possimus facilis culpa fugit vero nesciunt."),
            //   ),
            // ),
          ],
        ),
      ),

      // body: RichText(
      //   text: TextSpan(
      //     text: 'Hello ',
      //     style: Theme.of(context).textTheme.caption,
      //     // DefaultTextStyle.of(context).style,
      //     // children: const <TextSpan>[
      //     //   TextSpan(
      //     //       text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
      //     //   TextSpan(text: ' world!'),
      //     // ],
      //   ),
      // ),
    );
  }

  // Widget _buildTitle() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: FractionalOffset.topCenter,
  //         end: FractionalOffset.bottomCenter,
  //         colors: <Color>[
  //           Colors.black.withOpacity(0.4),
  //           Colors.grey.withOpacity(0.0),
  //         ],
  //       ),
  //     ),
  //     // padding: EdgeInsets.only(
  //     //   left: 8,
  //     //   top: 32,
  //     //   right: 8,
  //     //   bottom: 8,
  //     // ),
  //     child: Text(
  //       widget.unit.title,
  //       style: TextStyle(
  //         fontSize: 18,
  //         fontWeight: FontWeight.w600,
  //         color: Colors.white,
  //       ),
  //       maxLines: 1,
  //       overflow: TextOverflow.ellipsis,
  //     ),
  //   );
  // }

  Container _buildBadge() {
    var unit = widget.unit;
    return Container(
      color: unit.sex == Sex.male
          ? Colors.blueAccent.withOpacity(0.8)
          : Colors.redAccent.withOpacity(0.8),
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 12),
      child: Row(
        children: [
          Icon(
            unit.sex == Sex.male ? Icons.male : Icons.female,
            color: Colors.white,
          ),
          Text(
            formatAge(unit),
            style: TextStyle(
              // fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    // if (!_isBottom) {
    //   return SizedBox(
    //     height: kButtonHeight,
    //   );
    // }
    return Row(
      children: <Widget>[
        // if (unit.price == null) GiftButton(unit) else PriceButton(unit),
        _buildBadge(),
        Spacer(),
        // Icon(
        //   Icons.share,
        // ),
        // SizedBox(width: 16),
        // TextButton.icon(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.share,
        //   ),
        //   label: Text(""),
        // ),
        Tooltip(
          message: 'Share',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Material(
              child: InkWell(
                onTap: () {
                  // TODO: реализовать DeepLink
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Icon(
                    Icons.share,
                    // color: Colors.black.withOpacity(0.8),
                    // size: iconSize,
                  ),
                ),
              ),
            ),
          ),
        ),
        Tooltip(
          message: 'Favorite',
          child: TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border,
              ),
              label: Text("123")),
        ),

        // SizedBox(
        //   width: kButtonWidth,
        //   height: kButtonHeight,
        //   child: ShareButton(unit),
        // ),
        // SizedBox(
        //   width: kButtonWidth,
        //   height: kButtonHeight,
        //   child: WishButton(unit),
        // ),
      ],
    );
  }

  Widget _buildTitle() {
    var unit = widget.unit;

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Text(
        unit.title,
        style: Theme.of(context).textTheme.headline6,
        // .copyWith(color: Colors.red),
        // maxLines: 2,
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
