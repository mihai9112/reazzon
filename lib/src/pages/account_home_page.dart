import 'package:flutter/material.dart';
import 'package:reazzon/src/helpers/filter_icon.dart';
import 'package:reazzon/src/helpers/spinner.dart';
import 'package:reazzon/src/pages/filter_page.dart';
import 'package:reazzon/src/services/user_repository.dart';

class AccountHomePage extends StatefulWidget {
  @override
  _AccountHomePageState createState() => _AccountHomePageState();
}

class _AccountHomePageState extends State<AccountHomePage> {
  List<String> filteredList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<AccountHomeEntity>>(
          stream: (filteredList == null)
              ? userRepository.users()
              : userRepository.filterUsers(filteredList),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0)
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.separated(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _AccountHomePageItem(snapshot.data[index],
                          onTapped: () {
                        userRepository
                            .sendRequest(snapshot.data[index].userId)
                            .then((success) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor:
                                  (success) ? Colors.green : Colors.red,
                              content: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                    (success) ? 'Request Sent' : 'Try Again',
                                    style: TextStyle(color: Colors.white)),
                              )));
                        });
                      });
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
                  ),
                );
              return Center(child: Text('Empty'));
            }

            return Center(child: Spinner());
          }),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Home", style: TextStyle(color: Colors.blueAccent)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(FilterIcon.filter_list_01, color: Colors.blue, size: 28),
            onPressed: () async {
              var x = await Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => FilterDialog()));
              setState(() {
                if (x != null) {
                  if (x.list.length > 0) {
                    filteredList = x.list;
                  } else {
                    filteredList = null;
                  }
                } else {
                  filteredList = null;
                }
              });
            },
          ),
        ],
      ),
    );
    ;
  }
}

class _AccountHomePageItem extends StatelessWidget {
  final AccountHomeEntity accountHomeEntity;
  final Function onTapped;

  _AccountHomePageItem(this.accountHomeEntity, {this.onTapped});
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
            Padding(
              padding: EdgeInsets.all(8),
              child: IconButton(
                icon: Icon(Icons.add_comment),
                onPressed: this.onTapped,
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
        maxLines: 1,
        style: TextStyle(fontSize: 10, color: Colors.black.withOpacity(0.45)),
      ),
    );
  }
}
