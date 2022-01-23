import 'package:atlas/src/screens/country_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String getContinents = """
  query {
    continents {
      name
      code
    }
  }
""";

class ContinentsScreen extends StatelessWidget {
  const ContinentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Continents'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Query(
          options: QueryOptions(document: gql(getContinents)),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Text(
                'Loading ...',
                style: TextStyle(fontSize: 20.0),
              );
            }

            List continents = result.data?['continents'];

            return ListView.builder(
              itemCount: continents.length,
              itemBuilder: (context, index) {
                final continent = continents[index];

                return ListTile(
                  title: Text(continent['name']),
                  subtitle: Text(continent['code']),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) {
                        return CountryListScreen(
                          continentCode: continent['code'],
                          continent: continent['name'],
                        );
                      }),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
