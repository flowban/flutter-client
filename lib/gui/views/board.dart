import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/material.dart';
import 'package:boardview/boardview.dart';
import 'package:sprint/constants/text_constants.dart';
import 'package:sprint/gui/widgets/BoardItemObject.dart';
import 'package:sprint/gui/widgets/BoardListObject.dart';

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final List<BoardListObject> _listData = [
    BoardListObject(title: "List title 1", items: [
      BoardItemObject(title: 'Perro'),
      BoardItemObject(title: 'Gato'),
      BoardItemObject(title: 'Huron')
    ]),
    BoardListObject(title: "List title 2"),
  ];

  //Can be used to animate to different sections of the BoardView
  BoardViewController boardViewController = BoardViewController();

  @override
  Widget build(BuildContext context) {
    List<BoardList> lists = [];
    for (int i = 0; i < _listData.length; i++) {
      lists.add(_createBoardList(_listData[i]) as BoardList);
    }
    return BoardView(
      lists: lists,
      boardViewController: boardViewController,
    );
  }

// Create board list.
  Widget _createBoardList(BoardListObject list) {
    List<BoardItem> items = [];
    for (int i = 0; i < list.items!.length; i++) {
      items.insert(i, buildBoardItem(list.items![i]) as BoardItem);
    }

    return BoardList(
      onStartDragList: (int? listIndex) {},
      onTapList: (int? listIndex) async {},
      onDropList: (int? listIndex, int? oldListIndex) {
        //Update our local list data
        var list = _listData[oldListIndex!];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex!, list);
      },
      headerBackgroundColor: const Color.fromARGB(255, 235, 236, 240),
      backgroundColor: const Color.fromARGB(255, 235, 236, 240),
      header: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  list.title!,
                  style: const TextStyle(fontSize: 20),
                ))),
      ],
      items: items,
    );
  }

  //Build board Item
  Widget buildBoardItem(BoardItemObject itemObject) {
    final myController = TextEditingController();

    return BoardItem(
        onStartDragItem:
            (int? listIndex, int? itemIndex, BoardItemState? state) {},
        onDropItem: (int? listIndex, int? itemIndex, int? oldListIndex,
            int? oldItemIndex, BoardItemState? state) {
          //Used to update our local item data
          var item = _listData[oldListIndex!].items![oldItemIndex!];
          _listData[oldListIndex].items!.removeAt(oldItemIndex);
          _listData[listIndex!].items!.insert(itemIndex!, item);
        },
        onTapItem:
            (int? listIndex, int? itemIndex, BoardItemState? state) async {},
        item: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EditableText(
              autofocus: true,
              maxLines: null,
              backgroundCursorColor: Colors.amber,
              cursorColor: Colors.green,
              style: textStyleTitleSearch,
              focusNode: FocusNode(),
              controller: myController,
              onChanged: (val) {
                if (myController.text.isEmpty) {
                  setState(() {
                    if (_listData[0].items!.isNotEmpty) {
                      _listData
                          .removeWhere((element) => element.items!.isEmpty);
                    }
                  });
                } // myController.text = val;
              },
            ),
          ),
        ));
  }
}
