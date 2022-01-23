import 'package:atlas/src/screens/country_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CountryListScreen extends StatelessWidget {
  const CountryListScreen({
    Key? key,
    required this.continentCode,
    required this.continent,
  }) : super(key: key);
  final String continentCode;
  final String continent;

  @override
  Widget build(BuildContext context) {
    String getCountries = """
      query {
        countries(filter: {
          continent: {
            in: "$continentCode"
          }
        }) {
          name
          code
          phone
          capital
        }
      }
    """;

    return Scaffold(
      appBar: AppBar(
        title: Text(continent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Query(
          options: QueryOptions(document: gql(getCountries)),
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

            List countries = result.data?['countries'];

            return ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                String imageUrl =
                    'https://countryflagsapi.com/png/${country['code']}';

                return ListTile(
                  title: Text(country['name']),
                  subtitle: Text(country['capital'] ?? 'No Capital'),
                  leading: Image.network(
                    imageUrl,
                    width: 50,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  trailing: Text("+${country['phone']}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) {
                        return CountryDetail(
                          countryCode: country['code'],
                          countryName: country['name'],
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
