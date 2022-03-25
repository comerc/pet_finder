import 'package:flutter/material.dart';
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
    final unit = widget.unit;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<_PopupMenuValue>(
            // icon: Icon(Icons.more_horiz), // TODO: вертикальные точки в Android?
            onSelected: (_PopupMenuValue value) async {
              if (value == _PopupMenuValue.edit) {
                navigator.push(EditUnitScreen(unit: unit).getRoute());
              }
              if (value == _PopupMenuValue.toModerate) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Жалоба отправлена модератору.'),
                  ),
                );
                // TODO: отправить жалобу модератору
              }
            },
            itemBuilder: (BuildContext context) {
              final result = <PopupMenuEntry<_PopupMenuValue>>[];
              // final profile = getBloc<ProfileCubit>(context).state.profile;
              final isMy = unit.member.id ==
                  '0'; // TODO: profile.member.id == member.id;
              if (isMy) {
                result.add(
                  PopupMenuItem(
                    value: _PopupMenuValue.edit,
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.black87),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                );
              } else {
                result.add(
                  PopupMenuItem(
                    value: _PopupMenuValue.toModerate,
                    child: Row(
                      children: [
                        Icon(Icons.flag, color: Colors.black87),
                        SizedBox(width: 8),
                        Text('Пожаловаться'),
                      ],
                    ),
                  ),
                );
              }
              // TODO: if not isMy
              // TODO: _PopupMenuValue.askQuestion
              return result;
            },
          ),
        ],
      ),
      // FIXED: Scaffold.extendBodyBehindAppBar https://github.com/flutter/flutter/issues/14842
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: width,
              child: GestureDetector(
                onTap: () {
                  out('onTap');
                },
                child: Hero(
                  tag: unit.imageUrl,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: getImageProvider(unit.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Avatar(
                          url: unit.member.imageUrl!,
                          onTap: () async {
                            final values = [
                              // 'Telegram',
                              // 'Skype',
                              'WhatsApp',
                              'Vider',
                              'Call',
                              // 'SMS',
                              // 'Email',
                            ];
                            // https://agvento.com/web-development/shablony-ssylok-messendzhery/
                            final result = await showChoiceDialog(
                              context: context,
                              values: values,
                              title: unit.member.displayName ?? 'Unknown',
                            );
                            out(result);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
            ),
          ],
        ),
      ),
    );
  }

  Container _buildBadge() {
    final unit = widget.unit;
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
        //   onLongPress: () {}, // чтобы сократить время для splashColor
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
              type: MaterialType.transparency,
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
    final unit = widget.unit;

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

enum _PopupMenuValue { edit, toModerate, askQuestion }

const snackBar = SnackBar(
  content: Text('Yay! A SnackBar!'),
);
