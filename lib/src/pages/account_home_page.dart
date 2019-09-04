import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/account_home_bloc.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_entity.dart';
import 'package:reazzon/src/helpers/spinner.dart';

class AccountHomePage extends StatefulWidget {
  @override
  _AccountHomePageState createState() => _AccountHomePageState();
}

class _AccountHomePageState extends State<AccountHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AccountHomeEntity>>(
        stream: AccountHomeBloc().users(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {},
                  child: _AccountHomePageItem(snapshot.data[index]),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(vertical: 2),
                    color: Color(0XFFE0E0E0),
                    width: MediaQuery.of(context).size.width - 72 - 16,
                  ),
                );
              },
            );
          }

          return Center(child: Spinner());
        });
    ;
  }
}

class _AccountHomePageItem extends StatelessWidget {
  AccountHomeEntity accountHomeEntity;

  _AccountHomePageItem(this.accountHomeEntity);
  @override
  Widget build(BuildContext context) {
    double _size = 54;

    TextStyle itemNameStyle;

    itemNameStyle = Theme.of(context).textTheme.title.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        );

    return Container(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.network(
                this.accountHomeEntity.imgURL,
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
                width: _size,
                height: _size,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      this.accountHomeEntity.fullName,
                      style: itemNameStyle,
                      maxLines: 1,
                    ),
                    SizedBox(height: 4),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 6,
                      runSpacing: 4,
                      children: _buildReazzonListWidget(
                          this.accountHomeEntity.reazzons),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReazzonListWidget(List<String> reazzons) {
    List<Widget> reazzonList = [];

    for (var reazzon in reazzons) {
      reazzonList.add(_buildReazzonWidget(reazzon));
    }

    return reazzonList;
  }

  Widget _buildReazzonWidget(String reazzon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        reazzon,
        style: TextStyle(fontSize: 10, color: Colors.black.withOpacity(0.45)),
      ),
    );
  }
}
