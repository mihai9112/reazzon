import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reazzon/src/blocs/filter_bloc.dart';
import 'package:reazzon/src/models/reazzon.dart';

class FilterDialog extends StatefulWidget {
  @override
  FilterDialogState createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog> {
  FilterBloc filterBloc;

  @override
  void initState() {
    filterBloc = FilterBloc();

    Reazzon.allReazzons().forEach(
        (r) => filterBloc.filterEntities.add(FilterEntity(r.value, false)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Filter Users'),
        actions: <Widget>[
          FlatButton(
            child: Text('SAVE',
                style: theme.textTheme.body1.copyWith(color: Colors.white)),
            onPressed: () {
              List<String> _list = [];
              filterBloc.filterEntities
                  .where((filterEntity) => filterEntity.isSelected)
                  .forEach((filterEntity) {
                _list.add(filterEntity.value);
              });

              Navigator.of(context).pop(SELECTEDLIST(_list));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 16),
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: Item(),
          ),
        ),
      )
    );
  }
}

class Item extends StatefulWidget {
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  FilterBloc filterBloc;

  @override
  void initState() {
    filterBloc = BlocProvider.of<FilterBloc>(context);

    Reazzon.allReazzons().forEach(
        (r) => filterBloc.filterEntities.add(FilterEntity(r.value, false)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: _reazzonsListWidget(context),
    );
  }

  _reazzonsListWidget(context) {
    List<Widget> widgets = [];

    for (int index = 0; index < filterBloc.filterEntities.length; index++) {
      widgets.add(_item(index));
    }

    return widgets;
  }

  Widget _item(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          filterBloc.filterEntities[index].isSelected =
              !filterBloc.filterEntities[index].isSelected;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: filterBloc.filterEntities[index].isSelected
                ? Colors.blue
                : Colors.grey,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            filterBloc.filterEntities[index].value,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
            ),
          ),
        ),
      ),
    );
  }
}

class SELECTEDLIST {
  List<String> list;

  SELECTEDLIST(this.list);
}
