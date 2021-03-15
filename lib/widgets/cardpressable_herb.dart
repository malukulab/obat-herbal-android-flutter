import 'dart:io';

import 'package:flutter/material.dart';

class CardPressabelHerb extends StatelessWidget {
  final GestureTapCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final String? title;
  final String? description;
  final String? photo;
  final bool? isEditable;
  final GestureTapCallback? onDestroy;
  final GestureTapCallback? onEditable;
  // ignore: non_constant_identifier_names
  final IMAGE_FALLBACK_PLECHOLDER = 'assets/images/placeholder.png';



  CardPressabelHerb({
    this.onPressed,
    this.padding,
    this.title,
    this.description,
    this.photo,
    this.isEditable,
    this.onDestroy,
    this.onEditable
  });

  Widget _buildSingleAction() {
    // actions popupmenu.
    // ignore: non_constant_identifier_names
    final POPUPMENU_EDIT = 'edit';
    // ignore: non_constant_identifier_names
    final POPUPMENU_DELETE = 'delete';

    return PopupMenuButton(
      onSelected: (String? value) {
        if (value == POPUPMENU_EDIT) {
          return onEditable!();
        }

        return onDestroy!();
      },
      icon: Icon(Icons.more_vert_rounded, color: Colors.grey[700]),
      itemBuilder: (BuildContext context) {
      return List.of([
        PopupMenuItem(value: POPUPMENU_EDIT, child: Text('Ubah')),
        PopupMenuItem(
          value: POPUPMENU_DELETE,
          child: Text('Hapus', style: TextStyle(color: Colors.red))),
      ]);
    });
  }

  ImageProvider<Object> _buildResolveCardImage(String? pathOfImage) {
    if (pathOfImage!.isNotEmpty) {
      return FileImage(File(pathOfImage));
    }

    return ExactAssetImage(IMAGE_FALLBACK_PLECHOLDER);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: padding,
        child: Row(
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.black12,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(3.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: _buildResolveCardImage(photo!)
                )
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title!,
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600
                            )
                          ),
                          SizedBox(height: 5.0),
                          Expanded(
                            child: Text(
                              description!,
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black45, height: 1.50)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildSingleAction()
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
