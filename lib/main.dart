import 'package:atlas/src/screens/continents_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink('https://countries.trevorblades.com/');

    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    ));

    return GraphQLProvider(
      client: client,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ContinentsScreen(),
      ),
    );
  }
}
