import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedItems = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, item) {
          if (item.isOdd) {
            return Divider(
              thickness: 0.25,
              color: Colors.amberAccent[100],
            );
          }

          final index = item ~/ 2;

          if (index >= _randomWordPairs.length) {
            _randomWordPairs.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_randomWordPairs[index], index);
        });
  }

  Widget _buildRow(WordPair pair, int index) {
    final isExists = _savedItems.contains(pair);

    return ListTile(
      title: Text(
        '($index) ${pair.asPascalCase}',
        style: const TextStyle(fontSize: 18),
      ),
      trailing: Icon(isExists ? Icons.favorite : Icons.favorite_border,
          color: isExists ? Colors.red : null),
      onTap: () {
        setState(() {
          if (isExists) {
            _savedItems.remove(pair);
          } else {
            _savedItems.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> _tiles = _savedItems.map((WordPair pair) {
        return ListTile(
            title: Text(
          pair.asPascalCase,
          style: const TextStyle(fontSize: 18),
        ));
      });

      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: _tiles).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Items'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordPair Generator'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildList(),
    );
  }
}
