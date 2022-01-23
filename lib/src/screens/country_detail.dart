import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CountryDetail extends StatelessWidget {
  const CountryDetail({
    Key? key,
    required this.countryCode,
    required this.countryName,
  }) : super(key: key);

  final String countryCode;
  final String countryName;

  @override
  Widget build(BuildContext context) {
    String getCountry = """
      query {
        country(code: "$countryCode") {
        name
        code
        capital
        phone
        languages {
          name
          native
        }
        states {
          name
          code
        }
      }
      }
    """;

    return Scaffold(
      appBar: AppBar(
        title: Text(countryName),
      ),
      body: SingleChildScrollView(
        child: Query(
          options: QueryOptions(document: gql(getCountry)),
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

            final country = result.data?['country'];
            final languages = country['languages'];
            final states = country['states'];
            String imageUrl =
                'https://countryflagsapi.com/png/${country['code']}';

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(country['name']),
                    subtitle: Text(country['capital'] ?? 'No Capital'),
                    leading: Image.network(
                      imageUrl,
                      width: 50,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    trailing: Text("+${country['phone']}"),
                  ),
                  CountryItemList(
                    title: 'Languages',
                    list: languages,
                    listTileTitle: 'name',
                    listTileSubtitle: 'native',
                  ),
                  CountryItemList(
                    title: 'States',
                    list: states,
                    listTileTitle: 'name',
                    listTileSubtitle: 'code',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CountryItemList extends StatelessWidget {
  const CountryItemList({
    Key? key,
    required this.title,
    required this.list,
    required this.listTileTitle,
    required this.listTileSubtitle,
  }) : super(key: key);

  final String title;
  final List list;
  final String listTileTitle;
  final String listTileSubtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
            ),
          ),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];

            return ListTile(
              title: Text(item[listTileTitle]),
              subtitle: Text(item[listTileSubtitle]),
            );
          },
        )
      ],
    );
  }
}
