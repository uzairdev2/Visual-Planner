import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '../../../../Core/Firestore Services/firestore_services.dart';
import '../../../../Core/helper/helper.dart';
import '../../../../Core/models/Users Data/json_model.dart';
import '../../../../Core/models/commonData.dart';
import '../../../../Core/models/profile.dart';

class ProfilTile extends StatelessWidget {
  const ProfilTile({
    required this.data,
    required this.onPressedNotification,
    Key? key,
  }) : super(key: key);

  final Profile data;
  final Function() onPressedNotification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(commonModel.profileImageUrl.toString()),
      ),
      title: Text(
        commonModel.name.toString(),
        style: TextStyle(
          fontSize: 14,
          color: kFontColorPallets[0],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        commonModel.email.toString(),
        style: TextStyle(
          fontSize: 12,
          color: kFontColorPallets[2],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: onPressedNotification,
        icon: const Icon(EvaIcons.bellOutline),
        tooltip: "notification",
      ),
    );
  }
}
