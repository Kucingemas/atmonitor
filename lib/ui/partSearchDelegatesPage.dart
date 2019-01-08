import 'package:atmonitor/utils/colors.dart';
import 'package:flutter/material.dart';

class PartsSearchDelegatesPage extends SearchDelegate<String> {
  List<String> resultList = List<String>();
  List<String> partList = [
    "POWER_SUPPLY:120W:WPS120-FCE:T1-ATM",
    "ASSY:CARRIAGE_COVER",
    "SUB_ASSY:MOTOR_PICK_UP",
    "PCB Card Reader (Flicker card reader)",
    "MONITOR:LCD:1W:200CD:LP141WX3-TLN1:LG",
    "Receipt Printer Eco",
    "BELT:SE-N-SMV1:14Wx551x0.8t:G-CDU",
    "HDD:3.5INCH:SATA:1TB",
    "PC:FC_EX:G41:E7600:2GB:1DD1",
    "DVD-RW:CD-RW:SH-S182:TS-H652",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? Column()
          : IconButton(
              color: aBlue800,
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      color: aBlue800,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == null)
      return Center(
        child: Text("tidak ada data"),
      );
    if (partList
        .where((String partList) => "$partList".contains(query))
        .isNotEmpty)
      return ResultList(
          results: resultList,
          onSelected: (String result) {
            close(context, result);
          });
    if (partList
        .where((String partList) => "$partList".contains(query))
        .isEmpty)
      return Center(
        child: Text("tidak ada data"),
      );
    return Center();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = query.isEmpty
        ? partList
        : partList.where((String partList) => "$partList".contains(query));

    resultList = suggestions
        .map<String>((String suggestions) => "$suggestions")
        .toList();

    return SuggestionList(
      query: query,
      suggestions: suggestions
          .map<String>((String suggestions) => "$suggestions")
          .toList(),
      onSelected: (String suggestion) {
        close(context, suggestion);
      },
    );
  }
}

//body to load whenever a character added to the search bar (suggestion list)
class SuggestionList extends StatelessWidget {
  const SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int position) {
        return ListTile(
          trailing: Icon(
            Icons.add_circle,
            color: aBlue800,
          ),
          title: RichText(
              text: TextSpan(
                  text: suggestions[position]
                      .substring(0, suggestions[position].indexOf(query)),
                  style: theme.textTheme.subhead,
                  children: <TextSpan>[
                TextSpan(
                  text: suggestions[position].substring(
                      suggestions[position].indexOf(query),
                      suggestions[position].indexOf(query) + query.length),
                  style: theme.textTheme.subhead
                      .copyWith(fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: suggestions[position].substring(
                            suggestions[position].indexOf(query) +
                                query.length),
                        style: theme.textTheme.subhead),
                  ],
                ),
              ])),
          onTap: () {
            onSelected(suggestions[position]);
          },
        );
      },
    );
  }
}

//body when search button on keyboard pressed
class ResultList extends StatelessWidget {
  final List<String> results;
  final ValueChanged<String> onSelected;

  ResultList({this.results, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int position) {
        return ListTile(
          trailing: Icon(
            Icons.add_circle,
            color: aBlue800,
          ),
          title: Text(results[position].toString()),
          onTap: () {
            //TODO: part minus
            String result = results[position];
            onSelected(result);
          },
        );
      },
    );
  }
}
